#!/bin/bash
mysql.server start
cd ~/src/birthday_bot
PATH="/Applications/MacVim.app/Contents/MacOS:/usr/local/phantomjs-1.9.0-macosx/bin:/usr/local/heroku/bin:/Users/atsumitatsuya/.rbenv/shims:/Users/atsumitatsuya/.rbenv/versions/1.9.3-p194/bin/:/usr/local/sbin/:/usr/local/Cellar/mysql/5.5.25a/bin/:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bini;$PATH"

bundle exec rails runner -e production "Birthday.post_birthdays Date.today"
