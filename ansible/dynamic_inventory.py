#!/usr/bin/env python3
import os
import json

# Vérifier si le fichier JSON existe
if not os.path.exists("ansible/vm_ip.json"):
    print("Erreur : Le fichier vm_ip.json est manquant.")
    exit(1)

# Charger les informations d'IP de la VM
with open("ansible/vm_ip.json") as f:
    try:
        data = json.load(f)
        ip_address = data["vm_ip_address"]["value"]
    except KeyError as e:
        print(f"Erreur : Clé manquante dans le fichier JSON : {e}")
        exit(1)

# Générer un inventaire dynamique pour Ansible
inventory = {
    "webserver": {
        "hosts": [ip_address]
    }
}

# Sauvegarder l'inventaire dans un fichier JSON
inventory_file_path = "ansible/vm_inventory.json"
with open(inventory_file_path, "w") as inventory_file:
    json.dump(inventory, inventory_file, indent=4)

print(f"Inventaire dynamique généré avec succès et sauvegardé dans {inventory_file_path}.")
