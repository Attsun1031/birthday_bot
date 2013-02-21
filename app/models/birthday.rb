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

    birthdays.each do |e|
      # take interval between tweet
      sleep 5

      name = e.name_ja.present? ? e.name_ja : e.name_en
      tweet = MESSAGE_TEMPLATE % [
        e.introduction,
        name,
        e.comment
      ]
      begin
        Twitter.request_for_birthday_bot(:update_status, tweet)
        successes.append e
      rescue Twitter::Exceptions::InvalidStatusException
        errors.append e
      end
    end

    return successes, errors
  end
end
