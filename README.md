# terraform init

```
terraform init -backend-config="{bucket_name}" -backend-config="prefix=terraform/state"
```

# terraform apply to certain module

```
terraform apply -target=module.{module_name}
```
