- Create file `terraform.tfvars`:
```
cloud_id  = "<value>"
folder_id = "<value>"
```

- Run Terraform:
```
terraform apply
```

- Run Ansible Playbook:
```
ansible-playbook -i ansible/inventory.ini ansible/nextcloud-playbook.yml
```

- Open for configuring Nextcloud:
```
http://{IP}:8080/nextcloud
```

- Open after configuring Nextcloud:
```
http://{IP}/nextcloud
```

### Version with web-server: [`dev` branch](https://github.com/arshapshap/vvot33-task3-nextcloud/tree/dev)
