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
	web.vm.synced_folder "./app", "/home/vagrant/app"
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
    
    # creating first VM called webo  
      config.vm.define "webo" do |webo|
        
        webo.vm.box = "bento/ubuntu-18.04"
       # downloading ubuntu 18.04 image
    
        webo.vm.hostname = 'webo'
        # assigning host name to the VM
        
        webo.vm.network :private_network, ip: "192.168.56.13"
	webo.vm.synced_folder "./app", "/home/vagrant/app"
        #   assigning private IP
        
        #config.hostsupdater.aliases = ["development.webo"]
        # creating a link called development.web so we can access web page with this link instread of an IP   
            
      end
	# creating first VM called weboo  
      config.vm.define "weboo" do |weboo|
        
        weboo.vm.box = "bento/ubuntu-18.04"
       # downloading ubuntu 18.04 image
    
        weboo.vm.hostname = 'weboo'
        # assigning host name to the VM
        
        weboo.vm.network :private_network, ip: "192.168.56.21"
	weboo.vm.synced_folder "./app", "/home/vagrant/app"
        #   assigning private IP
        
        #config.hostsupdater.aliases = ["development.weboo"]
        # creating a link called development.web so we can access web page with this link instread of an IP   
            
      end
	# creating second VM called dbo
      config.vm.define "dbo" do |dbo|
        
        dbo.vm.box = "bento/ubuntu-18.04"
        
        dbo.vm.hostname = 'dbo'
        
        dbo.vm.network :private_network, ip: "192.168.56.20"
        
        #config.hostsupdater.aliases = ["development.dbo"]     
      end
    end
