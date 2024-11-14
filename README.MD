# Terraform Demo
## Последовательность
1. Создать облако
2. Создать сервисный аккаунт с правами "admin" на каталог
3. Выбить ключ под новый сервисный аккаунт и заменить в main.tf путь до нового ключа
4. Собрать packer'ом образ под новые виртуалки
5. Запустить terraform

## Полезные команды
### Инициализация с ключами для s3
```terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"```

### Packer сборка проекта
```packer build -var 'folder_id=b1gnu9b6p56oc5bvj3ji' packer.json```

### Получение ключа для сервисного аккаунта
```yc iam key create --service-account-id <account_id> --folder-name <folder_name> --output <...-key.json>```

### Создание только сетей и подсетей
```terraform apply -target=yandex_vpc_network.terraform-network -target=yandex_vpc_subnet.terraform-network-central1-a -target=yandex_vpc_subnet.terraform-network-central1-b```

### Подстановка в packer output из terraform
```packer build -var network=$(terraform output network_uuid) template.json```

### Получение списка самодельных образов
```yc compute image list```

### Получение списка стандартных образов
```yc compute image list --folder-id standard-images```

### Получение тикета Yandex Cloud
```export YC_TOKEN=$(yc iam create-token)```

### SSH ключ
```export TF_VAR_ssh_key='$'```

### Получение логов nginx
```sudo cat /var/log/nginx/access.log```
