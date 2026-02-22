# How to push to Artifact Registry
## Authentication
```
gcloud auth configure-docker us-central1-docker.pkg.dev
```

## Cloud Run Jobs
```
docker build --platform=linux/amd64 -t us-central1-docker.pkg.dev/[PROJECT_ID]/job/cloud-run-jobs:latest .
```

```
docker push us-central1-docker.pkg.dev/[PROJECT_ID]/job/cloud-run-jobs:latest
```

## Cloud Run Service
```
docker build --platform=linux/amd64 -t us-central1-docker.pkg.dev/${var.project}/app/cloud-run-service-app:latest .
```

```
docker push us-central1-docker.pkg.dev/${var.project}/app/cloud-run-service-app:latest
```

## Create Cloud Run
```
terraform apply -target=module.cloud_run
```

## Create Pub/Sub
```
terraform apply -target=module.iam.google_pubsub_topic.pubsub
terraform apply -target=module.iam.google_pubsub_subscription.cloud_run_subscription
```

## Grant Permissions
```
terraform apply -target=module.iam.google_project_iam_member.cloud_run_service_invoker
terraform apply -target=module.iam.google_project_iam_member.cloud_run_firestore_admin
terraform apply -target=module.iam.google_project_iam_member.cloud_run_bigquery_admin
```