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