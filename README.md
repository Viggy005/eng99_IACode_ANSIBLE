# Infrastructure as Code (IaC)
## Diagram:
![](pics/Vagrant_3VM.png)

## Vagrant File

```
# -*- mode: ruby -*-
 # vi: set ft=ruby :
 
 # All Vagrant configuration is done below. The "2" in Vagrant.configure
 # configures the configuration version (we support older styles for
 # backwards compatibility). Please don't change it unless you know what
 
 # MULTI SERVER/VMs environment 
 #
 Vagrant.configure("2") do |config|
    # creating are Ansible controller
      config.vm.define "controller" do |controller|
        
       controller.vm.box = "bento/ubuntu-18.04"
       
       controller.vm.hostname = 'controller'
       
       controller.vm.network :private_network, ip: "192.168.56.12"
  	controller.vm.synced_folder "./sendin", "/home/vagrant/controller"     

       # config.hostsupdater.aliases = ["development.controller"] 
       
      end 
    # creating first VM called web  
      config.vm.define "web" do |web|
        
        web.vm.box = "bento/ubuntu-18.04"
       # downloading ubuntu 18.04 image
    
        web.vm.hostname = 'web'
        # assigning host name to the VM
        
        web.vm.network :private_network, ip: "192.168.56.10"
        #   assigning private IP
        
        #config.hostsupdater.aliases = ["development.web"]
        # creating a link called development.web so we can access web page with this link instread of an IP   
            
      end
      
    # creating second VM called db
      config.vm.define "db" do |db|
        
        db.vm.box = "bento/ubuntu-18.04"
        
        db.vm.hostname = 'db'
        
        db.vm.network :private_network, ip: "192.168.56.11"
        
        #config.hostsupdater.aliases = ["development.db"]     
      end
    
    
    end

```

## provisioning File for the Controller VM

```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible -y

# replace file  /etc/ansible/hosts

sudo rm -rf /etc/ansible/hosts

sudo cp controller/hosts /etc/ansible/hosts

# to make sure we get the key, otherwise will have to ssh into agents first before running adhoc commands
ssh-keyscan -H 192.168.56.10>>~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.11>>~/.ssh/known_hosts

```

## content of /etc/ansible/hosts file
```
# comment

[web]
192.168.56.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant

[db]
192.168.56.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
```

# # Launch VM using Vagrant
### Step 1: navigate the where the vagrant file is stored on local host(cd command)
- make sure vagrant file has correct IP's

### Step 2: run command "vagrant up"
- this will create 3 VM's:
    1. Controller
    2. Web
    3. DB

### Step 3: Update and Upgrade all the VM's
- Run commands:
    ```
    1. sudo apt-get update
    2. sudo apt-get upgrade -y
    ```

### Step 4: Now we can ssh into the controller, web, Db using the commands
    
    1. vagrant ssh controller
    2. vagrant ssh web
    3. vagrant ssh db

### Step 5: Setting up the Controller VM with Ansible
- we have included in the vagrant file the command to sync a folder from local host to VM:
    - controller.vm.synced_folder "./sendin", "/home/vagrant/controller"
- this synced folder contain the provisioing script and the new hosts file
- Run the provision script (give chmod permission)
    ![](pics/provision_controller.png)
- edit the /etc/ansible/hosts file
    ![](pics/hosts_file.png)
- ssh into the db and app and exit(not required if we got the key in provision script)
    1. DB:  "ssh vagrant@192.168.56.11" 
    1. web:  "ssh vagrant@192.168.56.10"

- now we can run Adhoc commands on the web and Db VM's from our controller VM

## Adhoc Commands: we run them from controller VM ; it responds with information from the agent
- control agent nodes from controller
- Ad-hoc commands are one of the simplest ways of using Ansible. These are used when you want to issue some commands on a server or bunch of servers. The ad-hoc commands are not stored for future use, but it represents a fast way to interact with the desired servers.

- To put simply, Ansible ad hoc commands are one-liner Linux shell commands and playbooks are like a shell script, a collective of many commands with logic. Ansible ad hoc commands come handy when you want to perform a quick task
## Some Adhoc commands used:
- ansible all -m ping
- ansible web -m ping
- ansible db -m ping
- ansible web -a "uname -a"
- ansible db -a "uname -a"
- ansible all -a "uname -a"
- ansible db -a "ls -a"
    - this shows the directory structure of the db
    

# Reference notes Day 1

![](pics/sparta.png)


# Play Books:
- An Ansible playbook is an organized unit of scripts that defines work for a server configuration managed by the automation tool Ansible. Ansible is a configuration management tool that automates the configuration of multiple servers by the use of Ansible playbooks.
- Ansible playbooks are executed on a set, group, or classification of hosts, which together make up an Ansible inventory
- playbook file (.yml file)
  - create a file install_nginx.yml file
    -     sudo nano install_nginx.yml
![](pics/playbooks/nginx/playbook_nginx.png)
- Run the playbook
  -     ansible-playbook install_nginx.yml --syntax-check
![](pics/playbooks/nginx/playbook_nginx_run.png)
- check from controller if nginx in running on web
![](pics/playbooks/nginx/playbook_nginx_check.png)


# task 1
- create a playbook to install node in web
- copy app folder
- npm install and then start
- document these steps
## First iteration: manually ssh into web and run the app(npm install & npm start)
### Step 1: copy app folder into web using vagrant file
  ![](pics/playbooks/app/vagrantfile.png)
- vagarant reload web

### Step 2: create a provision file to set up the web app
- ssh into contoller
- navigate to /etc/ansible
- create a provision.sh to set up web app
  ![](pics/playbooks/app/provision_script.png)
### Step 3: Write the new yaml file (setup_app.yml)  
-  navigate to /etc/ansible
- create a file setup_app.yml
  -     sudo nano setup_app.js
  ![](pics/playbooks/app/playbook.png)

- Check syntax and Run the file(setup_app.yml) from controller
    1.ansible-playbook setup_app.yml --syntax-check
    2.ansible-playbook setup_app.yml 
- ssh into web server to start the app(npm install, npm start)

## Second iteration: no manual ssh


# Task 2: setup database from controller, install mongodb


- ssh into controller
- naviagte to /etc/ansible
- create file called setup_db.yml
![](pics/playbooks/db/playbook.png)
- run the file
![](pics/playbooks/db/run_check.png)

- check if mongodb is running on db from controller
![](pics/playbooks/db/run_check.png)

- ssh into database and edit the mongodb.conf file
    1. sudo nano /etc/mongodb.conf
    2. edit bind ip to 0.0.0.0
    3. restart mongodb
    4. enable mongodb

- ssh into web app 
- edit .bashrc file
- source .bashrc file
- cd app
- npm install
- cd seed
- node seed.js
- cd back to app
- pm2 start app.js

# task 3: execute 1 playbook to set up the application (app need manual starting: npm install, node seeds/seed.js,pm2 start app.js)

- vagrant up 2 VM's(app, db)
- ssh into contoller
- generate key for both VM's using command
  - ssh-keyscan -H 192.168.56.20>>~/.ssh/known_hosts
  - ssh-keyscan -H 192.168.56.21>>~/.ssh/known_hosts

- run the main_playbook
    ![](pics/files_in_controller/run_main_playbook.png)

- manually start the app
  - ssh into web vm
    ![](pics/files_in_controller/ssh_app_start.png)


## files on the /etc/ansible location of the conroller

- Hosts File: where we enter the details of machines we want to control
![](pics/files_in_controller/hosts.png)
- main playbook
![](pics/files_in_controller/main_playbook.png)

- Install nginx playbook
![](pics/files_in_controller/nginx_playbook.png)
  - nginx is restarted and enabled in the provision script to make chnages to /etc/nginx/sites-available/default work (reverse proxy)

- APP playbook
![](pics/files_in_controller/app_playbook.png)

- DB playbook
![](pics/files_in_controller/playbook_db.png)

- default: reverse proxy file (to be sent into web app)
![](pics/files_in_controller/reverse_proxy_default.png)

- provision script for web app(invoked in app playbook)

![](pics/files_in_controller/provision_app.png)

- mongodb.conf (needs to be sent into db vm)
  - sent to location /etc/mongodb.conf
  ![](pics/files_in_controller/mongodb_conf_bindip.png)
  - after file change mongdb has to be restarted it is written into playbook







