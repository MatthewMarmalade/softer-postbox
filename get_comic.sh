#!/bin/bash

# check that we have actually been handed a comic number
if [[ $# -ne 1 ]]
then
    echo "Usage: get_comic.sh [comic_number]" >> error_log.txt
    echo "Usage: get_comic.sh [comic_number]"
    exit 1
fi

curl -v -o "softer-postbox/temporary_comic_page.html" "https://www.asofterworld.com/index.php?id=$1"

# extract the image link from the html
comic_file_name=$(grep -o 'https://www.asofterworld.com/clean/.*\.jpg' softer-postbox/temporary_comic_page.html)

if [ $? -ne 0 ];
then
	echo "Failed to fetch comic $1, perhaps out of bounds?" >> softer-postbox/error_log.txt
	echo "Failed to fetch comic $1, perhaps out of bounds?"
	rm softer-postbox/temporary_comic_page.html
	exit 2
fi

# extract the title text from the html
comic_title_text=$(grep 'makeAlert' temporary_comic_page.html | grep -E -o "'.+'" | sed "s/'', //")

# fetch the comic image itself and store it in a file
curl -s -o "softer-postbox/comic_$1.jpg" "$comic_file_name"

echo "$comic_title_text"

rm softer-postbox/temporary_comic_page.html
