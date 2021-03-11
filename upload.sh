#!/bin/sh

# Please set the name and email. 
# Because MWeb can't get your github global setting.


# git add --ignore-removal .
git add .
git commit -m "`date '+%y-%m-%d %H:%M:%S'`"
git push

hexo clean
hexo g
hexo d