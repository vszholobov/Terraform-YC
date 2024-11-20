export YC_TOKEN=$(yc iam create-token) # yandex cloud access token
export TF_VAR_ssh_key=$(cat ./oslogin-ssh/oslogin-ssh.pub) # terraform ssh key env variable
export ANSIBLE_HOST_KEY_CHECKING=False # disable ansible ssh accept
