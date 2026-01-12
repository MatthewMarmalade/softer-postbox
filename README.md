# softer-postbox
A simple automatic comic emailer

## Description
This is a little script collection that performs the following steps:
1. Downloads the image from the next page of the webcomic 'A Softer World'
2. Emails that image to the recipient list in the config

This is intended to support automatically emailing webcomic entries (to myself, pretty much, though I made it scale to multiple recipients just because) with some kind of frequency (daily, weekly, monthly).

It's basically just some bash scripting that makes use of curl to download the images and post the email, the Gmail SMTP server with a Google App Password to send the mail, and cron to handle the scheduling.

## Usage
For my purposes this project is hosted on a very small cloud server. The repository is installed at the top level using a git clone. The crontab job line (added with `crontab -e`) looks like this:
`0 16 * * * ./softer-postbox/cron_check_postbox.sh`

The config folder has a couple of individual text files storing relevant information. They're empty in this repository (for privacy/security) and need to be populated before anything will work:
- sender.txt needs the email address the mail will be sent from
- gapp.txt needs a valid google app password (you can find how to create these pretty easily online) for this email address
- recipients.txt is a newline-separated list of email addresses to send the comics to

### Caveats
Here's some things I came across while working on this project that might trip others up as well if trying to do similar things:
- curl can be tricky to diagnose; a lot of information is packed into a single line. Recommend using -v to make the output verbose if it isn't behaving exactly as expected; specific errors (like incorrect passwords) are very hard to diagnose otherwise
- Google App Passwords can't be made by accounts without 2-factor-authentication enabled.
- Google App Passwords can't be made by accounts that are under 13 and/or under a day old.
- Google App Passwords present as four groups of four characters (16 total) with spaces in between. These spaces must be removed before use!
- I spent a while getting a strange error about SSL protocol alerts, supposedly because I was using outdated TLS, despite that not being the case -- switching from smtps.gmail.com to smtp.gmail.com fixed this, but I doubt that was the actual fix -- it appeared nonsensically from one day to the next without (I think) anything changing on my end, and didn't get resolved by any number of updates. Pick your favorite arcane incantation if you come across this one.

Using curl to send emails through gmail is supposed to be usage-limited (for good reason) but even in testing I never came up against any such limits.

## Background
This is a very silly little project spawned from my desire to read the entirety of 'A Softer World', a fantastic comic by Emily Horne and Joey Comeau. Unfortunately, my life tends to be pretty intensely impacted when I dive into a new comic with immediate access to the 'next' button, i.e. I spend all my time reading it and not doing anything else I ought to be doing (see: Questionable Content, Dumbing of Age, and though it's not a webcomic, Worm). I also find A Softer World to be highly *poetic* -- the kind of work I want to sit with, consume slowly, and linger upon. 'How nice it would be,' I wondered, 'to experience this as if it were still being released, one arbitrary chronometric unit at a time? With an email feed, say?'.

And thus this little re-delve into the world of shell scripting (a language/framework I find fascinatingly useful, but whose design is just esoteric and illogical enough that I've never quite gotten it from the cache down into disk) was born. And now I have emails arriving once a day with comics in them.

That's all. I don't expect this to be terribly useful to anybody else, but it sure is to me. If you come across this and want to make something similar, it's unlikely it will work for you out of the box -- the particulars of A Softer World's site setup and such are fairly baked in, and there are ways this could be made much more polished and extensible, but... I hope it at least sets you on the path to your own version, with clear examples of how I've solved some of the problems I came across! Go ahead and get in touch if you have any questions.
