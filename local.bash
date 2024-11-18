export YC_TOKEN=$(yc iam create-token)
export TF_VAR_ssh_key=$(cat ./oslogin-ssh/oslogin-ssh.pub)
#export TF_VAR_ssh_key=$(cat ~/.ssh/id_ed25519.pub)
