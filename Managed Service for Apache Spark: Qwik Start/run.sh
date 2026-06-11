#!/bin/bash

# ================================
# Google Cloud Dataproc Lab Script
# ================================

# ---- Set variables ----
PROJECT_ID=$(gcloud config get-value project)
REGION="europe-west3"
ZONE="europe-west3-a"

CLUSTER_NAME="example-cluster"

echo "Using Project: $PROJECT_ID"

# ---- Enable Dataproc API (if not already enabled) ----
echo "Enabling Dataproc API..."
gcloud services enable dataproc.googleapis.com

# ---- Create Dataproc cluster ----
echo "Creating Dataproc cluster: $CLUSTER_NAME ..."

gcloud dataproc clusters create $CLUSTER_NAME \
    --region=$REGION \
    --zone=$ZONE \
    --master-machine-type=e2-standard-2 \
    --worker-machine-type=e2-standard-2 \
    --master-boot-disk-size=30GB \
    --worker-boot-disk-size=30GB \
    --num-workers=2 \
    --image-version=2.1-debian11 \
    --project=$PROJECT_ID

echo "Cluster creation initiated..."

# ---- Submit SparkPi job ----
echo "Submitting SparkPi job..."

gcloud dataproc jobs submit spark \
    --cluster=$CLUSTER_NAME \
    --region=$REGION \
    --class=org.apache.spark.examples.SparkPi \
    --jars=file:///usr/lib/spark/examples/jars/spark-examples.jar \
    -- 1000

echo "Job submitted."

# ---- OPTIONAL: Scale cluster to 4 workers ----
echo "Updating cluster worker nodes to 4..."

gcloud dataproc clusters update $CLUSTER_NAME \
    --region=$REGION \
    --num-workers=4

echo "Cluster scaling request submitted."

# ---- Done ----
echo "Lab automation completed."
