# coding: utf-8

require 'date'
require 'birthday'

class PostTodaysBirthdayTask
  def self.run
    today = Date.today
    Birthday.post_birthdays today
  end
end
