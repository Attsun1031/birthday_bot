# coding: utf-8

require 'twitter'

class Birthday < ActiveRecord::Base
  attr_accessible :birthday, :comment, :introduction, :name_en, :name_ja

  MESSAGE_TEMPLATE = '今日は%s%sの誕生日！%s'

  # 誕生日メッセージをポストする
  def post_birthday
    message = build_birthday_message
    Twitter.request_for_birthday_bot(:update_status, message)
  end

  # birthday で検索を行う
  # ==== Args
  # target_date :: 対象の日付。
  # ignore_year :: 年を無視して検索を行うか。デフォルト true
  def self.find_by_birthday target_date, ignore_year = true
    unless ignore_year
      return super target_date
    end
    where_clause = 'birthday LIKE ?', "%" + target_date.strftime("%m%d")
    return Birthday.where where_clause
  end

  # 対象日が誕生日のデータを Twitter にポストする
  def self.post_birthdays target_date
    birthdays = find_by_birthday target_date
    birthdays.each do |birthday|
      take_interval_between_post
      post_each_birthday birthday
    end
  end

  private
  def build_birthday_message
    name = name_ja.present? ? name_ja : name_en
    tweet = MESSAGE_TEMPLATE % [introduction, name, comment]
    return tweet
  end

  def self.take_interval_between_post
    sleep 5
  end

  def self.post_each_birthday birthday
    begin
      birthday.post_birthday
    rescue Twitter::Exceptions::InvalidStatusException => exception
      logger.error "Failed to post birthday. name: %s, reason: %s" % [name, exception.message]
    end
  end

end
