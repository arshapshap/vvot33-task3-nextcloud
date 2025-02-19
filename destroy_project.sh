if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters. Using: ./destroy_project <PROJECT_NAME>"
fi

project_name=$1

terraform destroy \
    -target yandex_compute_disk.boot-disk-$project_name \
    -target yandex_compute_instance.nextcloud-vm-$project_name \
    -target yandex_dns_recordset.record-$project_name \
    -target null_resource.add-domain-to-inventory-$project_name \
    -target null_resource.add-ip-to-inventory-$project_name \
    -target null_resource.add-known-host-$project_name \
    -auto-approve

if [ $? -eq 0 ]; then
    rm ansible/inventory-$project_name.ini
    rm project-$project_name.tf
else
    echo "Terraform destroy failed"
    exit 1
fi