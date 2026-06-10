#!/bin/bash

# ----------------------------
# IAM CUSTOM ROLES LAB SCRIPT
# ----------------------------

echo "Step 0: Setup"
gcloud auth list
gcloud config list project
gcloud config set compute/region us-central1


echo "Step 1: List testable permissions"
gcloud iam list-testable-permissions \
  //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID


echo "Step 2: Describe predefined roles"
gcloud iam roles describe roles/viewer
gcloud iam roles describe roles/editor


echo "Step 3: List grantable roles"
gcloud iam list-grantable-roles \
  //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID


echo "Step 4: Create custom role using YAML"

cat > role-definition.yaml <<EOF
title: "Role Editor"
description: "Edit access for App Versions"
stage: "ALPHA"
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
EOF

gcloud iam roles create editor \
  --project $DEVSHELL_PROJECT_ID \
  --file role-definition.yaml


echo "Step 5: Create custom role using flags"
gcloud iam roles create viewer \
  --project $DEVSHELL_PROJECT_ID \
  --title "Role Viewer" \
  --description "Custom role description." \
  --permissions compute.instances.get,compute.instances.list \
  --stage ALPHA


echo "Step 6: List roles"
gcloud iam roles list --project $DEVSHELL_PROJECT_ID
gcloud iam roles list


echo "Step 7: Update role using YAML"

gcloud iam roles describe editor --project $DEVSHELL_PROJECT_ID > new-role-definition.yaml

echo "- storage.buckets.get" >> new-role-definition.yaml
echo "- storage.buckets.list" >> new-role-definition.yaml

gcloud iam roles update editor \
  --project $DEVSHELL_PROJECT_ID \
  --file new-role-definition.yaml


echo "Step 8: Update role using flags"
gcloud iam roles update viewer \
  --project $DEVSHELL_PROJECT_ID \
  --add-permissions storage.buckets.get,storage.buckets.list


echo "Step 9: Disable role"
gcloud iam roles update viewer \
  --project $DEVSHELL_PROJECT_ID \
  --stage DISABLED


echo "Step 10: Delete role"
gcloud iam roles delete viewer \
  --project $DEVSHELL_PROJECT_ID


echo "Step 11: Restore role"
gcloud iam roles undelete viewer \
  --project $DEVSHELL_PROJECT_ID


echo "LAB COMPLETED"
