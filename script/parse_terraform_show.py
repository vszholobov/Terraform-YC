import json
import sys

def extract_nat_ip_addresses(data):
    results = []

    # Перейти к структуре values > root_module > child_modules
    child_modules = data.get("values", {}).get("root_module", {}).get("child_modules", [])
    for module in child_modules:
        resources = module.get("resources", [])
        for resource in resources:
            # Проверить, что type равен "yandex_compute_instance"
            if resource.get("type") == "yandex_compute_instance":
                # Достать NAT IP address
                nat_ips = resource.get("values", {}).get("network_interface", [{}])[0].get("nat_ip_address")
                if nat_ips:
                    results.append(nat_ips)
    return results

def main():
    try:
        # Чтение JSON из стандартного ввода
        json_input = sys.stdin.read()
        data = json.loads(json_input)
    except json.JSONDecodeError as e:
        print(f"Invalid JSON: {e}", file=sys.stderr)
        sys.exit(1)

    # Извлечение NAT IP адресов
    nat_ip_addresses = extract_nat_ip_addresses(data)

    # Вывод результатов
    for ip in nat_ip_addresses:
        print(ip)

if __name__ == "__main__":
    main()
