import sys


def main(inventory_file_name, ssh_user_name):
    print(f"inventory_file_name={inventory_file_name}\n")
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
            print("Invalid input")

    web_servers = "\n".join([f"{server['name']} ansible_host={server['ip']}" for server in servers])
    inventory = f"""
[inventory]
enable_plugins=ini

[web_servers:vars]
ansible_connection=ssh
ansible_user={ssh_user_name}

[web_servers]
{web_servers}
"""
    # debug output
    print(f"format_ansible_inventory.py:\n{inventory.strip()}\n")

    # result config
    with open(inventory_file_name, "w") as f:
        f.write(inventory.strip())


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
