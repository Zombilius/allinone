#!/bin/bash
#
# https://cloud.google.com/kubernetes-engine/docs/tutorials/persistent-disk
# Просмотрите используемые манифесты yaml? в каталоге wordpress-persistent-disks/ :
# wordpress-volumeclaim.yaml wordpress-service.yaml wordpress_cloudsql.yaml.template wordpress_cloudsql.yaml

# В Cloud Shell включите GKE и API администратора Cloud SQL:
gcloud services enable container.googleapis.com sqladmin.googleapis.com

gcloud config set compute/region europe-west1
export PROJECT_ID=lab-gke-wordpre
git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples
cd kubernetes-engine-samples/wordpress-persistent-disks
WORKING_DIR=$(pwd)

# В Cloud Shell создайте кластер GKE с именем persistent-disk-tutorial:
CLUSTER_NAME=persistent-disk-tutorial
gcloud container clusters create-auto $CLUSTER_NAME

# подключитесь к новому кластеру:
gcloud container clusters get-credentials $CLUSTER_NAME --region europe-west1

### Создание PV и PVC с поддержкой Persistent Disk
# В Cloud Shell разверните файл манифеста:
kubectl apply -f $WORKING_DIR/wordpress-volumeclaim.yaml
# проверить статус. Это PersistentVolumeClaim остается в Pendingсостоянии, пока вы не используете
kubectl get persistentvolumeclaim

### Создание экземпляра Cloud SQL для MySQL
# создайте экземпляр с именем mysql-wordpress-instance:
INSTANCE_NAME=mysql-wordpress-instance
gcloud sql instances create $INSTANCE_NAME

# Добавьте имя подключения экземпляра в качестве переменной среды:
export INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe $INSTANCE_NAME \
    --format='value(connectionName)')

echo $INSTANCE_CONNECTION_NAME
#> lab-gke-wordpre:us-central1:mysql-wordpress-instance

# Создайте базу данных для WordPress для хранения своих данных:
gcloud sql databases create wordpress --instance $INSTANCE_NAME

# Создайте имя пользователя базы данных wordpressи пароль для WordPress для аутентификации в экземпляре:
CLOUD_SQL_PASSWORD=$(openssl rand -base64 18)
gcloud sql users create wordpress --host=% --instance $INSTANCE_NAME \
    --password $CLOUD_SQL_PASSWORD


### Развертывание WordPress
# Чтобы разрешить вашему приложению WordPress доступ к экземпляру MySQL через прокси-сервер Cloud SQL, создайте учетную запись службы:
SA_NAME=cloudsql-proxy
gcloud iam service-accounts create $SA_NAME --display-name $SA_NAME

# Добавьте адрес электронной почты учетной записи службы в качестве переменной среды:
SA_EMAIL=$(gcloud iam service-accounts list \
    --filter=displayName:$SA_NAME \
    --format='value(email)')

# Добавьте cloudsql.clientроль в свой сервисный аккаунт:
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --role roles/cloudsql.client \
    --member serviceAccount:$SA_EMAIL

# Создайте ключ для учетной записи службы:
gcloud iam service-accounts keys create $WORKING_DIR/key.json \
    --iam-account $SA_EMAIL

# Создайте секрет Kubernetes для учетных данных MySQL:
kubectl create secret generic cloudsql-db-credentials \
    --from-literal username=wordpress \
    --from-literal password=$CLOUD_SQL_PASSWORD

# Создайте секрет Kubernetes для учетных данных учетной записи службы:
kubectl create secret generic cloudsql-instance-credentials \
    --from-file $WORKING_DIR/key.json

# Подготовьте файл, заменив INSTANCE_CONNECTION_NAME переменную среды:
cat $WORKING_DIR/wordpress_cloudsql.yaml.template | envsubst > \
    $WORKING_DIR/wordpress_cloudsql.yaml

# Разверните wordpress_cloudsql.yamlфайл манифеста:
kubectl create -f $WORKING_DIR/wordpress_cloudsql.yaml

# Развертывание этого файла манифеста занимает несколько минут, пока постоянный диск подключен к вычислительному узлу.
# Наблюдайте за развертыванием, чтобы увидеть изменение статуса на running:
kubectl get pod -l app=wordpress --watch

# Создайте сервис из type:LoadBalancer:
kubectl create -f $WORKING_DIR/wordpress-service.yaml

# Создание балансировщика нагрузки занимает несколько минут.
# Наблюдайте за развертыванием и подождите, пока службе не будет назначен внешний IP-адрес:
kubectl get svc -l app=wordpress --watch

# В браузере откройте http://EXTERNAL_IP из вывода предыдцщей команды


