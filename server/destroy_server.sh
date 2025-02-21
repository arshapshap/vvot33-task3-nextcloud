ip=$(terraform output server-vm-ip | tr -d '"')
if [[ $ip == *"No outputs found"* ]]; then
    echo "No server exists"
    exit 0
fi

home=/home/ubuntu
ssh ubuntu@$ip "$home/nextcloud/destroy_all_projects.sh"

if [ $? -ne 0 ]; then
    echo "Destroying projects failed."
    read -p "Continue? (y/n) " -n 2 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Destroying server"
terraform destroy -auto-approve

if [ $? -ne 0 ]; then
    echo "Terraform destroy failed"
    exit 1
fi