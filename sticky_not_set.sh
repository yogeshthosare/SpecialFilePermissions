
# This code has minor variation with sticky not set, and we can observ the output. In this case federerr user can write to bfile and can delete it as well. 

RED='\033[0;31m'
NC='\033[0m' # No Color

RmDir(){
sudo rm -rf /usr/sportsdir
}
DirPermsLs(){
echo -e "\n${RED}__directory permissons of sportsdir__${NC}"
sudo ls -l /usr | grep sportsdir

echo -e "\n${RED}__directory permissons of tennisdir__${NC}"
sudo ls -l /usr/sportsdir | grep tennisdir

echo -e "\n${RED}__directory permissons of wimbleson and frenchopen__${NC}"
sudo ls -l /usr/sportsdir/tennisdir
}

echo -e "\n${RED}__Cleaning first__${NC}"

sudo groupdel tennis
sudo userdel federer
sudo userdel nadal
RmDir

echo -e "\n${RED}__Creating Groups, Dirs, And Users__${NC}"

sudo mkdir -p /usr/sportsdir/tennisdir/wimbledon
sudo mkdir -p /usr/sportsdir/tennisdir/frenchopen
DirPermsLs

sudo groupadd -g 3001 tennis
sudo useradd -u 4001 federer
sudo useradd -u 4002 nadal
sudo usermod -a -G tennis federer
sudo usermod -a -G tennis nadal

echo -e "\n${RED}__Allowing tennis group access and directory permissions to 770${NC}"
sudo chgrp -R tennis /usr/sportsdir/tennisdir/wimbledon
sudo chgrp -R tennis /usr/sportsdir/tennisdir/frenchopen
sudo chmod 770 -R /usr/sportsdir/tennisdir/wimbledon  #660 don't work Directories need x bit set (for directory that bit is seen as search bit) to open.
sudo chmod 770 -R /usr/sportsdir/tennisdir/frenchopen
sudo chmod g+s -R /usr/sportsdir/tennisdir/frenchopen

echo -e "\n${RED}__Creating afile and bfile with user federer and nadal__${NC}"
sudo su -c "touch /usr/sportsdir/tennisdir/wimbledon/afile" federer
sudo su -c "touch /usr/sportsdir/tennisdir/frenchopen/bfile" nadal
echo -e "\n${RED}__Created afile and bfile with user federer and nadal__${NC}"
echo -e "\n${RED}__files created and permissions__${NC}"
sudo ls -l /usr/sportsdir/tennisdir/wimbledon/
sudo ls -l /usr/sportsdir/tennisdir/frenchopen/
echo -e "\n${RED}__directory permissions__${NC}"
sudo ls -l /usr/sportsdir/tennisdir/

echo -e "\nthis will be allowd since wimbledon/afile is anyways owned by federer 
sudo su -c 'echo "I am fed, nadals rival " > /usr/sportsdir/tennisdir/wimbledon/afile' federer"
sudo su -c 'echo "I am fed, nadals rival " > /usr/sportsdir/tennisdir/wimbledon/afile' federer


echo -e "\nthis will be allowd since setgid bit is set for b file thus fed can write in it
even when bfile was created by nadal, federer can write because of setgid bit
more importantly fedrer can even delete it. 
to resist this from happening we need to set sticky bit on bfile.
sudo su -c 'echo "I am fed, nadals rival " >> /usr/sportsdir/tennisdir/frenchopen/bfile' federer ##################"
sudo ls -l /usr/sportsdir/tennisdir/frenchopen/bfile
sudo chmod 777 /usr/sportsdir/tennisdir/frenchopen/bfile
sudo ls -l /usr/sportsdir/tennisdir/frenchopen/bfile
sudo ls -ld /usr/sportsdir/tennisdir/frenchopen
sudo su -c 'echo "I am fed, nadals rival " >> /usr/sportsdir/tennisdir/frenchopen/bfile' federer
sudo su -c 'rm /usr/sportsdir/tennisdir/frenchopen/bfile' federer


echo -e "\n${RED}__files created and permissions__${NC}"
sudo ls -l /usr/sportsdir/tennisdir/wimbledon/
sudo ls -l /usr/sportsdir/tennisdir/frenchopen/

DirPermsLs
RmDir

