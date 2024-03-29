echo -e "Cleaning up Containers..."
sudo docker stop indy &> /dev/null
sudo docker rm indy &> /dev/null
sudo docker network rm ansible-net &> /dev/null
rm /tmp/labrunning &> /dev/null

sudo docker stop bender fry zoidberg farnsworth indy &> /dev/null
sudo docker rm bender fry zoidberg farnsworth indy &> /dev/null
sudo docker network rm ansible-net &> /dev/null
rm /tmp/labrunning &> /dev/null
echo -e "Containers Cleared!\n"

echo -e "Assembling Planet Express team...\n"

### Create networks
sudo docker network create --opt com.docker.network.driver.mtu=1450 --subnet 10.10.2.0/24 ansible-net

FILE_PATH=$HOME/.config/dockerfiles/ansible

wget -nc https://static.alta3.com/projects/ansible/modules/ssh-bender.tar.gz -P $FILE_PATH
wget -nc https://static.alta3.com/projects/ansible/modules/ssh-fry.tar.gz -P $FILE_PATH
wget -nc https://static.alta3.com/projects/ansible/modules/ssh-zoidberg.tar.gz -P $FILE_PATH
wget -nc https://static.alta3.com/projects/ansible/modules/ssh-farnsworth.tar.gz -P $FILE_PATH

sudo docker image load -i $FILE_PATH/ssh-bender.tar.gz
sudo docker image load -i $FILE_PATH/ssh-fry.tar.gz
sudo docker image load -i $FILE_PATH/ssh-zoidberg.tar.gz
sudo docker image load -i $FILE_PATH/ssh-farnsworth.tar.gz

### Launch containers and connect networks
sudo docker run -d  --name bender      -h bender     --ip 10.10.2.3 --network ansible-net ssh-bender
sudo docker run -d  --name fry         -h fry        --ip 10.10.2.4 --network ansible-net ssh-fry
sudo docker run -d  --name zoidberg    -h zoidberg   --ip 10.10.2.5 --network ansible-net ssh-zoidberg
sudo docker run -d  --name farnsworth  -h farnsworth --ip 10.10.2.6 --network ansible-net ssh-farnsworth

echo -e "\nGOOD NEWS, EVERYONE! Complete!\n"

sudo apt install sshpass -y

echo -e ".ansible.cfg Updated (/home/student/.ansible.cfg)"
curl https://static.alta3.com/projects/ansible/deploy/ansiblecfg --create-dirs -o ~/.ansible.cfg

echo -e "Inventory File Updated (/home/student/mycode/inv/dev/hosts)"
curl https://static.alta3.com/projects/ansible/deploy/hosts --create-dirs -o ~/mycode/inv/dev/hosts

echo -e "Nethosts Inventory File Updated (/home/student/mycode/inv/dev/nethosts)"
curl https://static.alta3.com/projects/ansible/deploy/nethosts --create-dirs -o ~/mycode/inv/dev/nethosts

curl https://static.alta3.com/projects/ansible/deploy/pubkeymover --create-dirs -o ~/pubkeymover.yml
ansible-playbook ~/pubkeymover.yml -i ~/mycode/inv/dev/hosts
