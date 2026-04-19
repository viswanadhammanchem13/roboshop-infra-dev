#! /bin/bash
sudo dnf install ansible -y
ansible-pull -U https://github.com/viswanadhammanchem13/Ansible_Roles_RoboShop-tf.git -e component=$1  -e env=$2 main.yaml