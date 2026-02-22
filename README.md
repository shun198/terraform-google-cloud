# setup gcloud settings
```
gcloud config set project "{project_name}"
gcloud auth application-default login
```

# terraform init

Before running, authenticate with Google Cloud (see below).

```
terraform init -backend-config="bucket={bucket_name}" -backend-config="prefix=terraform/state"
```

# terraform apply to certain module

```
terraform apply -target=module.{module_name}
```
