# /usr/bin/env ruby
# coding: utf-8

require 'date'
require 'birthday'

class NotifyBirthdayTask
  def self.run
    today = Date.today
    Birthday.post_birthday today
  end
end
