zombilius@cloudshell:~ (lab-gke-wordpre)$ gcloud config set compute/region europe-west1
Updated property [compute/region].
zombilius@cloudshell:~ (lab-gke-wordpre)$ export PROJECT_ID=lab-gke-wordprezombilius@cloudshell:~ (lab-gke-wordpre)$ export PROJECT_ID=lab-gke-wordpress
zombilius@cloudshell:~ (lab-gke-wordpre)$ git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples
Cloning into 'kubernetes-engine-samples'...
remote: Enumerating objects: 3409, done.remote: Counting objects: 100% (55/55), done.
remote: Compressing objects: 100% (41/41), done.
remote: Total 3409 (delta 19), reused 41 (delta 13), pack-reused 3354
Receiving objects: 100% (3409/3409), 2.31 MiB | 10.69 MiB/s, done.
Resolving deltas: 100% (1919/1919), done.

zombilius@cloudshell:~ (lab-gke-wordpre)$ ls
kubernetes-engine-samples  README-cloudshell.txt  tfinfrazombilius@cloudshell:~ (lab-gke-wordpre)$ cd kubernetes-engine-samples/ai-ml/ cloudsql/ gke-scheduled-autoscaler/ gke-vpa-recommendations/ hello-app-redis/ network-policies/ terraform/ wordpress-persistent-disks/autopilot/ custom-metrics-autoscaling/  gke-stateful-kafka/ guestbook/ hello-app-tls/ quickstart/ try-gke/ workload-metrics/
batch/ .git/ gke-stateful-mysql/ hello-app/ load-balancing/ security/ whereami/
cloud-pubsub/ .github/ gke-stateful-postgres/ hello-app-cdn/ migrating-node-pool/ stateful-workload-filestore/ windows-multi-arch/

zombilius@cloudshell:~ (lab-gke-wordpre)$ cd kubernetes-engine-samples/wordpress-persistent-disks/

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ WORKING_DIR=$(pwd)

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ CLUSTER_NAME=persistent-disk-tutorial
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ gcloud container clusters create-auto $CLUSTER_NAME
Note: The Pod address range limits the maximum size of the cluster. Please refer to https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr to learn how to optimize IP address allocation.Creating cluster persistent-disk-tutorial in europe-west1... Cluster is being health-checked...working. Creating cluster persistent-disk-tutorial in europe-west1... Cluster is being health-checked (master Creating cluster persistent-disk-tutorial in europe-west1... Cluster is being health-checked (master is healthy)...working.. 
Creating cluster persistent-disk-tutorial in europe-west1... Cluster is being health-checked (master is healthy)...done. 
Created [https://container.googleapis.com/v1/projects/lab-gke-wordpre/zones/europe-west1/clusters/persistent-disk-tutorial].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/europe-west1/persistent-disk-tutorial?project=lab-gke-wordpre
kubeconfig entry generated for persistent-disk-tutorial.
NAME: persistent-disk-tutorial
LOCATION: europe-west1
MASTER_VERSION: 1.24.10-gke.2300
MASTER_IP: 34.79.138.92
MACHINE_TYPE: e2-medium
NODE_VERSION: 1.24.10-gke.2300
NUM_NODES: 3
STATUS: RUNNING

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ export PROJECT_ID=lab-gke-wordpre
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ gcloud container clusters get-credentials $CLUSTER_NAME --region europe-west1
Fetching cluster endpoint and auth data.
kubeconfig entry generated for persistent-disk-tutorial.
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ ll
total 40
drwxr-xr-x  2 zombilius zombilius 4096 Apr 22 13:50 ./
drwxr-xr-x 32 zombilius zombilius 4096 Apr 22 13:50 ../
-rw-r--r--  1 zombilius zombilius  872 Apr 22 13:50 mysql-service.yaml
-rw-r--r--  1 zombilius zombilius  945 Apr 22 13:50 mysql-volumeclaim.yaml
-rw-r--r--  1 zombilius zombilius 1567 Apr 22 13:50 mysql.yaml
-rw-r--r--  1 zombilius zombilius  440 Apr 22 13:50 README.md
-rw-r--r--  1 zombilius zombilius 2217 Apr 22 13:50 wordpress_cloudsql.yaml.template
-rw-r--r--  1 zombilius zombilius  942 Apr 22 13:50 wordpress-service.yaml
-rw-r--r--  1 zombilius zombilius  965 Apr 22 13:50 wordpress-volumeclaim.yaml
-rw-r--r--  1 zombilius zombilius 1590 Apr 22 13:50 wordpress.yaml
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ pwd
/home/zombilius/kubernetes-engine-samples/wordpress-persistent-disks

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl apply -f $WORKING_DIR/wordpress-volumeclaim.yaml
persistentvolumeclaim/wordpress-volumeclaim created
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl get persistentvolumeclaim
NAME STATUS VOLUME CAPACITY ACCESS MODES STORAGECLASS AGE
wordpress-volumeclaim Pending standard-rwo 60s
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ INSTANCE_NAME=mysql-wordpress-instance
gcloud sql instances create $INSTANCE_NAME
WARNING: Starting with release 233.0.0, you will need to specify either a region or a zone to create an instance.
Creating Cloud SQL instance for MYSQL_8_0...done. 
Created [https://sqladmin.googleapis.com/sql/v1beta4/projects/lab-gke-wordpre/instances/mysql-wordpress-instance].
NAME: mysql-wordpress-instance
DATABASE_VERSION: MYSQL_8_0
LOCATION: us-central1-f
TIER: db-n1-standard-1
PRIMARY_ADDRESS: 104.197.40.246
PRIVATE_ADDRESS: -
STATUS: RUNNABLE

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ export INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe $INSTANCE_NAME \
 --format='value(connectionName)')

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ echo $INSTANCE_CONNECTION_NAME
lab-gke-wordpre:us-central1:mysql-wordpress-instance

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ gcloud sql databases create wordpress --instance $INSTANCE_NAME
Creating Cloud SQL database...done. 
Created database [wordpress].
instance: mysql-wordpress-instance
name: wordpress
project: lab-gke-wordpre

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ CLOUD_SQL_PASSWORD=$(openssl rand -base64 18)
gcloud sql users create wordpress --host=% --instance $INSTANCE_NAME \
 --password $CLOUD_SQL_PASSWORD
Creating Cloud SQL user...done. 
Created user [wordpress].

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ echo $CLOUD_SQL_PASSWORD
RT1LoGXTCCZ8uZv1qpR6PA3M

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ SA_NAME=cloudsql-proxy
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ gcloud iam service-accounts create $SA_NAME --display-name $SA_NAME
Created service account [cloudsql-proxy].
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ SA_EMAIL=$(gcloud iam service-accounts list \
 --filter=displayName:$SA_NAME \
 --format='value(email)')

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ echo $SA_EMAIL
cloudsql-proxy@lab-gke-wordpre.iam.gserviceaccount.com

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ gcloud projects add-iam-policy-binding $PROJECT_ID \
 --role roles/cloudsql.client \
 --member serviceAccount:$SA_EMAIL
Updated IAM policy for project [lab-gke-wordpre].
bindings:
- members:
  - serviceAccount:cloudsql-proxy@lab-gke-wordpre.iam.gserviceaccount.com
  role: roles/cloudsql.client
- members:
  - serviceAccount:service-360435692562@compute-system.iam.gserviceaccount.com
  role: roles/compute.serviceAgent
- members:
  - serviceAccount:service-360435692562@container-engine-robot.iam.gserviceaccount.com
  role: roles/container.serviceAgent
- members:
  - serviceAccount:service-360435692562@containerregistry.iam.gserviceaccount.com
  role: roles/containerregistry.ServiceAgent
- members:
  - serviceAccount:360435692562-compute@developer.gserviceaccount.com
  - serviceAccount:360435692562@cloudservices.gserviceaccount.com
  role: roles/editor
- members:
  - user:zombilius@gmail.com
  role: roles/owner
- members:
  - serviceAccount:service-360435692562@gcp-sa-pubsub.iam.gserviceaccount.com
  role: roles/pubsub.serviceAgent
etag: BwX57XudT1E=
version: 1

zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ gcloud iam service-accounts keys create $WORKING_DIR/key.json \
 --iam-account $SA_EMAIL
created key [0a0fa192e3b8723c8bd79bf672f5a294f15dc62d] of type [json] as [/home/zombilius/kubernetes-engine-samples/wordpress-persistent-disks/key.json] for [cloudsql-proxy@lab-gke-wordpre.iam.gserviceaccount.com]
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ ll
total 44
drwxr-xr-x  2 zombilius zombilius 4096 Apr 22 14:21 ./
drwxr-xr-x 32 zombilius zombilius 4096 Apr 22 13:50 ../
-rw-------  1 zombilius zombilius 2328 Apr 22 14:21 key.json
-rw-r--r--  1 zombilius zombilius  872 Apr 22 13:50 mysql-service.yaml
-rw-r--r--  1 zombilius zombilius  945 Apr 22 14:03 mysql-volumeclaim.yaml
-rw-r--r--  1 zombilius zombilius 1567 Apr 22 13:50 mysql.yaml
-rw-r--r--  1 zombilius zombilius  440 Apr 22 13:50 README.md
-rw-r--r--  1 zombilius zombilius 2217 Apr 22 13:50 wordpress_cloudsql.yaml.template
-rw-r--r--  1 zombilius zombilius  942 Apr 22 13:50 wordpress-service.yaml
-rw-r--r--  1 zombilius zombilius  965 Apr 22 13:50 wordpress-volumeclaim.yaml
-rw-r--r--  1 zombilius zombilius 1590 Apr 22 13:50 wordpress.yaml
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl create secret generic cloudsql-db-credentials \
 --from-literal username=wordpress \
 --from-literal password=$CLOUD_SQL_PASSWORD
secret/cloudsql-db-credentials created
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl create secret generic cloudsql-instance-credentials \
 --from-file $WORKING_DIR/key.json
secret/cloudsql-instance-credentials created
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ ll
total 44
drwxr-xr-x  2 zombilius zombilius 4096 Apr 22 14:21 ./
drwxr-xr-x 32 zombilius zombilius 4096 Apr 22 13:50 ../
-rw-------  1 zombilius zombilius 2328 Apr 22 14:21 key.json
-rw-r--r--  1 zombilius zombilius  872 Apr 22 13:50 mysql-service.yaml
-rw-r--r--  1 zombilius zombilius  945 Apr 22 14:03 mysql-volumeclaim.yaml
-rw-r--r--  1 zombilius zombilius 1567 Apr 22 13:50 mysql.yaml
-rw-r--r--  1 zombilius zombilius  440 Apr 22 13:50 README.md
-rw-r--r--  1 zombilius zombilius 2217 Apr 22 13:50 wordpress_cloudsql.yaml.template
-rw-r--r--  1 zombilius zombilius  942 Apr 22 13:50 wordpress-service.yaml
-rw-r--r--  1 zombilius zombilius  965 Apr 22 13:50 wordpress-volumeclaim.yaml
-rw-r--r--  1 zombilius zombilius 1590 Apr 22 13:50 wordpress.yaml
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ cat $WORKING_DIR/wordpress_cloudsql.yaml.template | envsubst > \
 $WORKING_DIR/wordpress_cloudsql.yaml
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ ll
total 48
drwxr-xr-x  2 zombilius zombilius 4096 Apr 22 14:25 ./
drwxr-xr-x 32 zombilius zombilius 4096 Apr 22 13:50 ../
-rw-------  1 zombilius zombilius 2328 Apr 22 14:21 key.json
-rw-r--r--  1 zombilius zombilius  872 Apr 22 13:50 mysql-service.yaml
-rw-r--r--  1 zombilius zombilius  945 Apr 22 14:03 mysql-volumeclaim.yaml
-rw-r--r--  1 zombilius zombilius 1567 Apr 22 13:50 mysql.yaml
-rw-r--r--  1 zombilius zombilius  440 Apr 22 13:50 README.md
-rw-r--r--  1 zombilius zombilius 2243 Apr 22 14:25 wordpress_cloudsql.yaml
-rw-r--r--  1 zombilius zombilius 2217 Apr 22 13:50 wordpress_cloudsql.yaml.template
-rw-r--r--  1 zombilius zombilius  942 Apr 22 13:50 wordpress-service.yaml
-rw-r--r--  1 zombilius zombilius  965 Apr 22 13:50 wordpress-volumeclaim.yaml
-rw-r--r--  1 zombilius zombilius 1590 Apr 22 13:50 wordpress.yaml
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl create -f \$WORKING_DIR/wordpress_cloudsql.yaml
error: the path "$WORKING_DIR/wordpress_cloudsql.yaml" does not exist
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl create -f $WORKING_DIR/wordpress_cloudsql.yaml
Warning: Autopilot set default resource requests for Deployment default/wordpress, as resource requests were not specified. See http://g.co/gke/autopilot-defaults
deployment.apps/wordpress created
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl get pod -l app=wordpress --watch
NAME READY STATUS RESTARTS AGE
wordpress-7db59cbc5c-49fsg 0/2 Pending 0 21s
wordpress-7db59cbc5c-49fsg 0/2 Pending 0 2m10s
wordpress-7db59cbc5c-49fsg 0/2 ContainerCreating 0 2m11s

wordpress-7db59cbc5c-49fsg 2/2 Running 0 3m7s
^Czombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl create -f $WORKING_DIR/wordpress-service.yaml
service/wordpress created
zombilius@cloudshell:~/kubernetes-engine-samples/wordpress-persistent-disks (lab-gke-wordpre)$ kubectl get svc -l app=wordpress --watch
NAME TYPE CLUSTER-IP EXTERNAL-IP PORT(S) AGE
wordpress LoadBalancer 10.96.131.254 <pending> 80:30293/TCP 14s
wordpress LoadBalancer 10.96.131.254 34.79.197.56 80:30293/TCP 40s
