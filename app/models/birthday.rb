# coding: utf-8

require 'twitter'

class Birthday < ActiveRecord::Base
  attr_accessible :birthday, :comment, :introduction, :name_en, :name_ja

  MESSAGE_TEMPLATE = '今日は%s%sの誕生日！%s'

  # 対象日が誕生日のデータを Twitter にポストする
  def self.post_birthday target_date
    birthdays = Birthday.where('birthday LIKE ?', "%" + target_date.strftime("%m%d"))
    successes = []
    errors = []

    birthdays.each do |employee|
      # take interval between tweet
      sleep 5

      name = employee.name_ja.present? ? employee.name_ja : employee.name_en
      tweet = MESSAGE_TEMPLATE % [
        employee.introduction,
        name,
        employee.comment
      ]
      begin
        Twitter.request_for_birthday_bot(:update_status, tweet)
        successes.append employee
      rescue Twitter::Exceptions::InvalidStatusException => exception
        logger.error "Failed to post birthday. name: %s, reason: %s" % [name, exception.message]
        errors.append employee
      end
    end

    return successes, errors
  end
end
