echo "Destroying all projects"

cd /home/$USER/nextcloud
if [ ! -d ".terraform" ]; then
    echo "Terraform not initialized"
    exit 0
fi

/home/$USER/terraform destroy -auto-approve

if [ $? -ne 0 ]; then
    echo "Terraform destroy failed"
    exit 1
fi

find . -maxdepth 1 -type f -name "project-*.tf" -exec rm {} \;
find ansible/ -maxdepth 1 -type f -name "inventory-*.ini" -exec rm {} \;