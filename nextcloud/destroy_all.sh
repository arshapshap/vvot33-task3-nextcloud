echo "Destroying all"

cd /home/$USER/nextcloud
/home/$USER/terraform destroy -auto-approve

if [ $? -ne 0 ]; then
    echo "Terraform destroy failed"
    exit 1
fi

find . -maxdepth 1 -type f -name "project-*.tf" -exec rm {} \;
find ansible/ -maxdepth 1 -type f -name "inventory-*.ini" -exec rm {} \;