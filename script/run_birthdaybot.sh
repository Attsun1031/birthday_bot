#!/bin/bash
export PATH=/usr/local/rvm/gems/ruby-1.9.2-p320@dotcloud/bin:/usr/local/rvm/gems/ruby-1.9.2-p320@global/bin:/usr/local/rvm/rubies/ruby-1.9.2-p320/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/jvm/java-6-sun/bin
export GEM_HOME=/usr/local/rvm/gems/ruby-1.9.2-p320@dotcloud
export GEM_PATH=/usr/local/rvm/gems/ruby-1.9.2-p320@dotcloud:/usr/local/rvm/gems/ruby-1.9.2-p320@global
export RAILS_ENV=production

cd ~/code
rails runner "Birthday.post_birthdays Date.today"
