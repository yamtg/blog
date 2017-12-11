#!/bin/sh

# Please set the name and email. 
# Because MWeb can't get your github global setting.


git add --ignore-removal .
git commit -m "`date '+%y-%m-%d %H:%M:%S'`"
git push -u origin master