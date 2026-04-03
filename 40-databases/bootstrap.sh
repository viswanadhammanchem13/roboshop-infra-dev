#! /bin/bash
component= $1
sudo dnf install ansible -y
ansible-pull -U https://github.com/viswanadhammanchem13/Ansible_Roles_RoboShop.git -e component=$1 main.yaml