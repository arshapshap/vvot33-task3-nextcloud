if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters. Using: ./destroy_project <PROJECT_NAME>"
fi

project_name=$1

echo "Destroying project '$project_name'"

cd /home/$USER/nextcloud
/home/$USER/terraform destroy \
    -target yandex_compute_disk.boot-disk-$project_name \
    -target yandex_compute_instance.nextcloud-vm-$project_name \
    -target yandex_dns_recordset.record-$project_name \
    -target null_resource.add-domain-to-inventory-$project_name \
    -target null_resource.add-ip-to-inventory-$project_name \
    -target null_resource.add-known-host-$project_name \
    -auto-approve

if [ $? -ne 0 ]; then
    echo "Terraform destroy failed"
    exit 1
fi

rm ansible/inventory-$project_name.ini
rm project-$project_name.tf