# WIREGUARD SCRIPTS

This repo holds two bash scripts.

- genWGClient.sh - Used to create user's wireguard tunnel.
- rmWGClient.sh - Used to remove user's wireguard tunnel.

> **genWGClient.sh**
When you run this script, it creates the user's tunnel and config file in the directory *~/client.configs*

> **rmWGClient.sh**
When you run this script, it removes the user's tunnel and moves the config file to the directory */home/ravpn/removed.client.configs* and renames the file *(Example: 2023-06-18-09-34.client.1144.conf)*
