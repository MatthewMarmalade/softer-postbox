#!/bin/bash

latest_comic=$(< config/latest_comic.txt)
next_comic=$(($latest_comic + 1))

./mail_comic.sh $next_comic

# if successful, update our latest comic count
if [ $? -eq 0 ]; then
	echo $next_comic > config/latest_comic.txt
else
	echo "Exit code $? does not equal 0"
fi