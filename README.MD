# Terraform and Ansible Demo

## Topics
1. Packer
2. Terraform modules
3. Terraform S3 state storage
4. Terraform CI/CD
5. Terraform data and resource

## Local Setup
1. Set env variable YC_TOKEN ```export YC_TOKEN=$(yc iam create-token)```
2. Set env variable TF_VAR_ssh_key ```export TF_VAR_ssh_key='your public ssh key'```
3. Set env variables ACCESS_KEY and SECRET_KEY by instruction: https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-state-storage#set-up-backend
4. Init terraform ```terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"```
5. Use curl or ! In browser update page with clearing cookies to actually see different hosts

## Useful commands
### Local launch setup
```source local.bash```

### Terraform initialization with specified S3 keys
```terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"```

### Generating ssh-key with specified user
```ssh-keygen -t ed25519 -f oslogin-ssh -C terraform```

### Packer image build
```packer build -var 'folder_id=b1gnu9b6p56oc5bvj3ji' packer.json```

### Parsing terraform output
```
source local.bash
terraform show -json | python3 script/parse_terraform_show.py | python3 script/format_ansible_inventory.py
echo $ANSIBLE_SSH_PRIVATE_KEY > ansible_key
ansible-playbook -i inventory.ini ansible/playbook.yaml
```

### Show current cloud state
```terraform show -json```

### Getting service account key
```yc iam key create --service-account-id <account_id> --folder-name <folder_name> --output <...-key.json>```

### Create networks and subnets
```terraform apply -target=yandex_vpc_network.terraform-network -target=yandex_vpc_subnet.terraform-network-central1-a -target=yandex_vpc_subnet.terraform-network-central1-b```

### Getting a list of custom images
```yc compute image list```

### Getting a list of standard images
```yc compute image list --folder-id standard-images```

### Getting Yandex Cloud token
```export YC_TOKEN=$(yc iam create-token)```

### Terraform ssh env variable
```export TF_VAR_ssh_key='your public ssh key'```

### Getting nginx logs
```sudo cat /var/log/nginx/access.log```

### Ansible initialization
```ansible-playbook -i inventory.ini playbook.yaml```
