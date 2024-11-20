export YC_TOKEN=$(yc iam create-token)
export TF_VAR_ssh_key=$(cat oslogin-ssh.pub)
export ANSIBLE_HOST_KEY_CHECKING=False
