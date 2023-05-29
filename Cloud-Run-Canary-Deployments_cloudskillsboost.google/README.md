# Cloud Run Canary Deployments.
## Google Cloud Self-Passed Labs. GSP1078.
## Fixes for version: "Manual Last Updated March 20, 2023, Lab Last Tested March 20, 2023"
### Overview
Missing files: branch-trigger.json-tmpl, tag-trigger.json-tmpl, master-trigger.json-tmpl, master-cloudbuild.yaml
Fixes in files: branch-cloudbuild.yaml, tag-cloudbuild.yaml

Create backup original files
```
cp -r ~/cloudrun-progression/labs/cloudrun-progression ~/cloudrun-progression.backup
```

- Copy *.json, *.yaml files from this folder to Cloud Shell
```
# do this as you like
```

- Change the PROJECT_ID and REGION in these files (these variables are set in the commands in this lab):
```
sed -i "s/\$REGION/${REGION}/g" *cloudbuild.yaml
sed -i "s/\$PROJECT_ID/${PROJECT_ID/}/g" *trigger.json
```

Use them when needed when doing a lab

Checked May 29, 2023

