sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible -y

sudo rm -rf /etc/ansible/hosts

touch /etc/ansible/hosts

echo "# comments" >> /etc/ansible/hosts

echo "[web]" >> /etc/ansible/hosts

echo "192.168.56.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> /etc/ansible/hosts
echo "[db]" >> /etc/ansible/hosts
echo "192.168.56.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> /etc/ansible/hosts
