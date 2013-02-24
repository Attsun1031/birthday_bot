# coding: utf-8

require 'spec_helper'
require 'twitter'
require 'oauth'

describe Twitter::TwitterAPI do
  before do
    @consumer = mock(OAuth::Consumer)
    OAuth::Consumer.stub!(:new).and_return(@consumer)
    @access_token = mock(OAuth::AccessToken)
  end

  describe "update_status" do
    it "should call access_token.post" do
      access_key = "access_key"
      access_secret = "access_secret"
      OAuth::AccessToken.should_receive(:from_hash).with(@consumer, {
        :oauth_token => access_key,
        :oauth_token_secret => access_secret
      }).and_return(@access_token)
      @access_token.should_receive(:post).with("https://api.twitter.com/1.1/statuses/update.json", :status => "tweet")

      api = Twitter::TwitterAPI.new("consumer_key_dummy", "consumer_secret_dummy")
      api.update_status(access_key, access_secret, "tweet")
    end

    it "should raise InvalidStatusException" do
      api = Twitter::TwitterAPI.new("consumer_key_dummy", "consumer_secret_dummy")
      proc {
        api.update_status("access_key", "access_secret", "a" * 141)
      }.should raise_error(Twitter::Exceptions::InvalidStatusException)
    end
  end
end

describe Twitter do
  describe "request_for_birthday_bot" do
    before do
      secret_yaml = {
        "twitter" => {
          "consumer_key" => "consumer_key_dummy",
          "consumer_secret" => "consumer_secret_dummy",
          "access_token" => "access_key_dummy",
          "access_token_secret" => "access_seret_dummy"
        }
      }
      YAML.stub!(:load_file).and_return(secret_yaml)
      @api = mock(Twitter::TwitterAPI)
    end

    it "should execute update_status" do
      Twitter::TwitterAPI.should_receive(:new).with("consumer_key_dummy", "consumer_secret_dummy").and_return(@api)
      @api.should_receive(:update_status).with("access_key_dummy", "access_seret_dummy", "tweet")

      result = Twitter.request_for_birthday_bot(:update_status, "tweet")
    end
  end
end
