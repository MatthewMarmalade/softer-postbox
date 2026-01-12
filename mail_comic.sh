#!/bin/bash

# check that we have actually been handed a comic number
if [[ $# -ne 1 ]]
then
    echo "Usage: mail_comic.sh [comic_number]"
    exit 1
fi

# Fetch sender email (stored externally, for security/configuration)
sender=$(cat softer-postbox/config/sender.txt)

# Fetch google app password (stored externally, for security/configuration)
gapp=$(cat softer-postbox/config/gapp.txt)

# Fetch the image and store the output (title text) in a variable using helper script
title_text=$(softer-postbox/get_comic.sh $1)

# Set subject to comic name and number
sub="A Softer World [$1]"

# Set up the body to include the title text and links
body=".

$title_text

(Powered by https://github.com/MatthewMarmalade/softer-postbox)"

# set file variable to where ./get_comic.sh has stored it
file="softer-postbox/comic_$1.jpg"

# MIME type for multiple type of input file extensions
MIMEType=`file --mime-type "$file" | sed 's/.*: //'`
# output of 'file' is name.type: mime_type_name, 
# so piping that result into the regular expression 
# that follows extracts *just* the mime type

# loop over every email address in the 'recipients' config file
success=0
while read receiver || [[ -n $receiver ]]; do
	response=$(curl -s --url 'smtp://smtp.gmail.com:587' --ssl-reqd \
		--mail-from $sender \
		--mail-rcpt $receiver \
		--user $sender:$gapp \
		-H "Subject: $sub" \
		-H "From: Marmalade Post <$sender>" \
		-H "To: $receiver" \
		-F '=(;type=multipart/mixed' \
		-F "file=@$file;type=$MIMEType;encoder=base64" \
		-F "=$body;type=text/plain" \
		-F '=)')
	if [ $? -eq 0 ]; then
		echo "Email sent to $receiver successfully."
		success=1
	else
		echo "Failed to send email to $receiver. Exit code $?, Response: $response"
	fi
done < softer-postbox/config/recipients.txt

rm $file

if [ $success -ne 1 ]; then
	echo "No mail delivered successfully (comic $1); is the recipients file empty?"
	exit 1
fi
