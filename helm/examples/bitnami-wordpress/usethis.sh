# https://github.com/bitnami/charts/tree/main/bitnami/wordpress

helm install -f myvalues.yaml mywp oci://registry-1.docker.io/bitnamicharts/wordpress
# or
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo wordpress
> NAME                   	CHART VERSION	APP VERSION	DESCRIPTION                                       
> bitnami/wordpress      	15.4.1       	6.2.0      	WordPress is the worlds most popular blogging ...
> ...
helm install -f myvalues.yaml mywp bitnami/wordpress
# or end

# See chart parameters and oiher
helm show values bitnami/wordpress

# See helm resources
helm list
helm status mywp

# check in browser
minikube service mywp-wordpress
minikube tunnel


## Upgrade ond rollback
# add in myvalues.02.yaml - image.tag: "6.1.0-debian-11-r11"

helm upgrade mywp -f myvalues.v02.yaml bitnami/wordpress
helm history mywp
> REVISION	UPDATED                 	STATUS    	CHART           	APP VERSION	DESCRIPTION     
> 1       	Thu Apr 20 19:28:38 2023	superseded	wordpress-15.4.1	6.2.0      	Install complete
> 2       	Thu Apr 20 20:19:15 2023	deployed  	wordpress-15.4.1	6.2.0      	Upgrade complete

helm rollback mywp 1
helm history mywp
> REVISION	UPDATED                 	STATUS    	CHART           	APP VERSION	DESCRIPTION     
> 1       	Thu Apr 20 19:28:38 2023	superseded	wordpress-15.4.1	6.2.0      	Install complete
> 2       	Thu Apr 20 20:19:15 2023	superseded	wordpress-15.4.1	6.2.0      	Upgrade complete
> 3       	Thu Apr 20 20:20:31 2023	deployed  	wordpress-15.4.1	6.2.0      	Rollback to 1   


helm delete mywp
# or
helm delete --purge habr

