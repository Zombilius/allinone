# Cloud Run Canary Deployments
## Google Cloud Self-Passed Labs. GSP1078
Fixes for version: `Manual Last Updated March 20, 2023, Lab Last Tested March 20, 2023`

### Overview

Missing files: `branch-trigger.json-tmpl, tag-trigger.json-tmpl, master-trigger.json-tmpl, master-cloudbuild.yaml`  
Errors in files: `branch-cloudbuild.yaml, tag-cloudbuild.yaml`

This is you need before *"Task 3. Enabling Dynamic Developer Deployments"*

### Instruction

- Create backup original files
```bash
cp -r ~/cloudrun-progression/labs/cloudrun-progression ~/cloudrun-progression.backup
```

- Copy \*.json, \*.yaml files from this folder to Cloud Shell
```bash
# do this as you like
```

- Change the *PROJECT_ID* and *REGION* (these variables are set in the commands in this lab):
```bash
sed -i "s/\$REGION/${REGION}/g" *cloudbuild.yaml
sed -i "s/\$PROJECT_ID/${PROJECT_ID/}/g" *trigger.json
```

- Keep doing the lab

*Checked May 29, 2023*

