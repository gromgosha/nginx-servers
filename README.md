## Repo to create droplets in DigitalOcean and to install nginx on it
This is example of rebrain devops course task. First, I create 2 hosts on DigitalOcean provider, then I configure it. This are made via terraform. Additional output is ```ansible_inventory.yml``` file with droplet hostnames and ip addresses for starting ansible playbook.
Then I install nginx on both droplets via ansible playbook and configuring server on it. 


To install nginx on server with this role, you should know vault pass.

Command to start installation `ansible-playbook install_server.yml -i ansible_inventory.yml --ask-vault-pass`

Or you can add pass to file and start with command `ansible-playbook install_server.yml -i ansible_inventory.yml --vault-password-file ~/vault.txt`