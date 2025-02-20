if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters. Using: ./setup_server.sh"
fi

echo "Setupping server"

email=$1

terraform_success=false
terraform_attempt_num=1
terraform_max_attempts=3
while [ $terraform_success = false ] && [ $terraform_attempt_num -le $terraform_max_attempts ]; do
  terraform apply -auto-approve

  if [ $? -eq 0 ]; then
    terraform_success=true
  else
    echo "Attempt $terraform_attempt_num/$terraform_max_attempts failed. Trying again..."
    terraform_attempt_num=$(( terraform_attempt_num + 1 ))
  fi
done

if [ $terraform_success = false ]; then
    echo "Terraform apply failed"
    exit 1
fi

echo "Copying files to server..."
ip=$(terraform output server-vm-ip | tr -d '"')
home=/home/ubuntu
scp -r ../nextcloud ubuntu@$ip:$home
scp -r ~/.yc-keys ubuntu@$ip:$home
scp terraform.tfvars ubuntu@$ip:$home/nextcloud
dns_zone_id=$(terraform output dns-zone-id | tr -d '"')
ssh ubuntu@$ip "echo >> $home/nextcloud/terraform.tfvars"
ssh ubuntu@$ip "echo 'dns_zone_id=\"$dns_zone_id\"' >> $home/nextcloud/terraform.tfvars"

echo "Running Ansible playbook..."
ansible-playbook -i ansible/inventory.ini -e ansible/secret-vars.yml ansible/server-playbook.yml

if [ $? -ne 0 ]; then
    echo "Ansible playbook failed"
    exit 1
fi

ssh ubuntu@$ip "cd $home/nextcloud; $home/terraform init"