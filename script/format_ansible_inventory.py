import sys

def main():
    servers = []
    name = "server"
    cnt = 1

    for line in sys.stdin.read().split("\n"):
        line.strip()
        if not line:
            break
        try:
            servers.append({"name": name + str(cnt), "ip": line})
            cnt += 1
        except ValueError:
            print("Некорректный ввод. Используйте формат 'server_name ip_address'.")

    # Генерация конфигурационного файла
    template = f"""
[web_servers:vars]
ansible_connection=ssh
ansible_ssh_private_key_file=./oslogin-ssh
ansible_user=terraform

[web_servers]
""" + "\n".join([f"{server['name']} ansible_host={server['ip']}" for server in servers])

    # Сохранение в файл
    output_file = "inventory.ini"
    with open(output_file, "w") as f:
        f.write(template.strip())

    print(f"Файл сгенерирован и сохранен в {output_file}.")

if __name__ == "__main__":
    main()
