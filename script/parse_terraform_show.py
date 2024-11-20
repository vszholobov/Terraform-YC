import json
import sys

def extract_nat_ip_addresses(data):
    results = []

    # values -> root_module -> child_modules
    child_modules = data.get("values", {}).get("root_module", {}).get("child_modules", [])
    for module in child_modules:
        resources = module.get("resources", [])
        for resource in resources:
            if resource.get("type") == "yandex_compute_instance":
                nat_ips = resource.get("values", {}).get("network_interface", [{}])[0].get("nat_ip_address")
                if nat_ips:
                    results.append(nat_ips)
    return results

def main():
    try:
        json_input = sys.stdin.read()
        data = json.loads(json_input)
    except json.JSONDecodeError as e:
        print(json_input, file=sys.stderr)
        print(f"\nInvalid JSON: {e}", file=sys.stderr)
        sys.exit(1)

    nat_ip_addresses = extract_nat_ip_addresses(data)

    for ip in nat_ip_addresses:
        print(ip)

if __name__ == "__main__":
    main()
