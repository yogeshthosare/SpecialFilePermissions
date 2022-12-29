#With below scrip two of my manny doubts are cleared. 

#My expectations: 
# If I create user federer and nadal, and put them in group tennis. Federer and Nadal users, should have access to create and read files, in a directory provided that directory is given group access.

# --> Now this has few minor details. Which initially I did not pay attention and ended up wasting lot of time. 

# 1) File permission to directories: Setting them to 660 doesn't work. We need to set it to 770. Now one would argue that why 660 fails. As a matter of fact, Directories need x bit set (for directory that bit is seen as search bit) to open (a file).
# 2) After setting directory permissions, files created in that directory still created with (username:username) as user and group. Which kind of makes sense. But then this prevents other user to read/write since group access is still users default group. 

#e.g. Nadal creates bfile, permsions to that file are nadal:nadal. So federer can not write into it  (although bfile is in frenchopen directory with group permisions tennis and federer is in group tennis)

# To overcome this, we need to set the setgid bit for group access. It will make sure that all files created in frenchopen directory are created with tennis group. Whoever creates it. Federer or nadal. And since actual files(not only directory) belongs to group now (not default group of user) anyone in the group tennis can edit it. 

# How to set setgid bit? 
#  --> $sudo chmod g+s -R /usr/sportsdir/tennisdir/frenchopen

# Also, if we were to do exactly the different. Meaning, - file can be deleted or renamed only by the file owner, directory owner and the root user. We would have used sticky bit for that.
# The command below shows how the sticky bit can be set.
# chmod +t

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
sudo userdel ronaldo
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
sudo su -c 'echo "I am fed, nadals rival " >> /usr/sportsdir/tennisdir/frenchopen/bfile' federer"
sudo su -c 'echo "I am fed, nadals rival " >> /usr/sportsdir/tennisdir/frenchopen/bfile' federer


echo -e "\nthis will not be allowed since setgid bit is not set for afile
sudo su -c 'echo "I am nadal, rogers rival " >> /usr/sportsdir/tennisdir/wimbledon/afile' nadal"
sudo su -c 'echo "I am nadal, rogers rival " >> /usr/sportsdir/tennisdir/wimbledon/afile' nadal

echo -e "\n${RED}__files created and permissions__${NC}"
sudo ls -l /usr/sportsdir/tennisdir/wimbledon/
sudo ls -l /usr/sportsdir/tennisdir/frenchopen/

DirPermsLs
RmDir
