General Overview : 1. Script setgit.sh ensures how users in a group can share, modify, read, write and access data from files created with inheritance from parent-groups directory ownership. 2. Also, with the help of sticky bit, how we achieve exactly different goals - user with users in a group can be resisted from modifying or deleting other users files or its content. This behaviour can be clearly seen if we check sticky.sh vs sticky_not_set.sh script. 


IN-DETAILS - 

With below scrip two of my many doubts are cleared. 

My expectations: If I create user federer and nadal, and put them in group tennis. Federer and Nadal users, should have access to create and read files, in a directory provided that directory is given group access.

Now this has few minor details. Which initially I did not pay attention and ended up wasting lot of time. 

1) File permission to directories: Setting them to 660 doesn't work. We need to set it to 770. Now one would argue that why 660 fails. As a matter of fact, Directories need x bit set (for directory that bit is seen as search bit) to open (a file).

2) After setting directory permissions, files created in that directory still created with (username:username) as user and group. Which kind of makes sense. But then this prevents other user to read/write since group access is still users default group. 

e.g. Nadal creates bfile, permsions to that file are nadal:nadal. So federer can not write into it  (although bfile is in frenchopen directory with group permisions tennis and federer is in group tennis)

To overcome this, we need to set the setgid bit for group access. It will make sure that all files created in frenchopen directory are created with tennis group. Whoever creates it. Federer or nadal. And since actual files(not only directory) belongs to group now (not default group of user) anyone in the group tennis can edit it. 

How to set setgid bit? 

```sudo chmod g+s -R /usr/sportsdir/tennisdir/frenchopen```


With above setup, we see files created with nadal:tennis. This makes federer eligible to read/write/delete files created by nadal (since he belogs to same group - tennis)

There comes sticky bit for rescue. 

i.e., if we were to do exactly the different. Meaning, - file can be deleted or renamed only by the file owner, directory owner and the root user. We would have used sticky bit for that

The command below shows how the sticky bit can be set

```sudo chmod +t /usr/sportsdir/tennisdir/frenchopen```
