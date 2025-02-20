- Go to folder `server`:
```
cd server
```

- Create file `terraform.tfvars`:
```
cloud_id  = "<value>"
folder_id = "<value>"
```

- Run server:
```
./setup_server.sh
```

- Create projects from server:
```
ssh ubuntu@{IP} "~/nextcloud/create_project.sh {PROJECT_NAME} {EMAIL} {PASSWORD}"
```

- Destroy projects by name:
```
ssh ubuntu@{IP} "~/nextcloud/destroy_project.sh {PROJECT_NAME}"
```

- Destroy all projects:
```
ssh ubuntu@{IP} "~/nextcloud/destroy_all_projects.sh"
```

- Destroy server after using:
```
./destroy_server.sh
```
