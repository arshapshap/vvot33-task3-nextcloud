if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters. Using: ./create_project <PROJECT_NAME> <USER_EMAIL> <USER_PASSWORD>"
fi

project_name=$1
user_email=$2
user_password=$3

echo "Creating project '$project_name' with user '$user_email' and password '$user_password'"

if [ ! -f project-$project_name.tf ]; then
  cp templates/project.tf.template project-$project_name.tf
  sed -i '' "s/{PROJECT_NAME}/$project_name/g" project-$project_name.tf
  sed -i '' "s/{USER_EMAIL}/$user_email/g" project-$project_name.tf
  sed -i '' "s/{USER_PASSWORD}/$user_password/g" project-$project_name.tf
fi

if [ ! -f ansible/inventory-$project_name.ini ]; then
  cp templates/inventory.ini.template ansible/inventory-$project_name.ini
  sed -i '' "s/{PROJECT_NAME}/$project_name/g" ansible/inventory-$project_name.ini
fi

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

if [ $terraform_success = true ]; then
    echo "Running Ansible playbook..."
    ansible-playbook -i ansible/inventory-$project_name.ini ansible/nextcloud-playbook.yml --extra-vars "email=$user_email password=$user_password"
else
    echo "Terraform apply failed"
    exit 1
fi