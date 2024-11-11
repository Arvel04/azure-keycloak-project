#!/usr/bin/env python3
import os
import json

# Vérifier si le fichier JSON existe
file_path = "ansible/vm_ip.json"
if not os.path.exists(file_path):
    print(f"Erreur : Le fichier {file_path} est manquant.")
    exit(1)

# Charger les informations d'IP de la VM
with open(file_path) as f:
    try:
        # Vérifiez d'abord si le fichier contient des données
        file_content = f.read()
        if not file_content:
            print(f"Erreur : Le fichier {file_path} est vide.")
            exit(1)
        
        # Chargez le contenu JSON
        data = json.loads(file_content)
        ip_address = data["public_ip_address"]["value"]
    except json.JSONDecodeError as e:
        print(f"Erreur de décodage JSON : {e}")
        exit(1)
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
