# coding: utf-8

require 'oauth'
require 'yaml'

module Twitter

  MAX_STATUS_LENGTH = 140

  # birthday_bot アプリケーション用に Twitter API をコールする
  def self.request_for_birthday_bot(api_name, *params)
    twitter_oauth_infos = YAML.load_file("config/oauth.yml")["twitter"]
    api = TwitterAPI.new(twitter_oauth_infos["consumer_key"], twitter_oauth_infos["consumer_secret"])
    params = [twitter_oauth_infos["access_token"], twitter_oauth_infos["access_token_secret"]] + params
    result = api.send(api_name, *params)
    return result
  end

  # Twitter API をコールする
  class TwitterAPI
    API_PREFIX = "https://api.twitter.com/"
    API_VER = "1.1"

    def initialize(consumer_key, consumer_secret)
      @consumer = create_consumer(consumer_key, consumer_secret)
    end

    def update_status(access_token, access_secret, status)
      validate_status status
      access_token = prepare_access_token(access_token, access_secret)
      api_url = build_api_url("/statuses/update.json")
      return access_token.post(api_url, :status => status)
    end

    private
    def create_consumer(consumer_key, consumer_secret)
      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
        :site => API_PREFIX,
        :scheme => :header
      })
      return consumer
    end

    def prepare_access_token(oauth_token, oauth_token_secret)
      token_hash = {
        :oauth_token => oauth_token,
        :oauth_token_secret => oauth_token_secret
      }
      access_token = OAuth::AccessToken.from_hash(@consumer, token_hash)
      return access_token
    end

    def build_api_url(path)
      return File.join(API_PREFIX, API_VER, path)
    end

    # ツイートが有効か確認する
    def validate_status status
      if status.length > MAX_STATUS_LENGTH
        raise Exceptions::InvalidStatusException,
          'Lenght of status is over the limit, length: %d, limit: %d' % [status.length, MAX_STATUS_LENGTH]
      end
      return true
    end
  end

  module Exceptions
    class InvalidStatusException < Exception
    end
  end
end
