# coding: utf-8

require 'spec_helper'
require 'date'
require 'twitter'

describe Birthday do
  describe "post_birthdays" do
    fixtures :birthdays

    before do
      Birthday.stub!(:sleep)
      Birthday.stub_chain(:logger, :error)
    end

    it "should post birthday comment" do
      Birthday.should_receive(:sleep).with(5).twice
      Twitter.should_receive(:request_for_birthday_bot).with(:update_status, "今日はDiana Rossの誕生日！")
      Twitter.should_receive(:request_for_birthday_bot).with(:update_status, "今日は世界を代表するジャズ・ピアニストである上原ひろみの誕生日！Brainは名盤でしょう。 http://goo.gl/short")
      Googl.should_receive(:shorten).with("http://ueharahiromi.com/").and_return("http://goo.gl/short")
      Birthday.post_birthdays Date.new(2013, 3, 26)
    end

    it "should not post" do
      Twitter.should_not_receive(:request_for_birthday_bot)
      Birthday.post_birthdays Date.new(2013, 3, 27)
    end

    context "over 140 chars" do
      it "should raise error" do
        Twitter.should_receive(:request_for_birthday_bot).with(:update_status, "今日はMax Roachの誕生日！")
        Twitter.should_receive(:request_for_birthday_bot).with(:update_status, "今日はドイツの生んだ早熟の天才、マイケル・シェンカーの誕生日！").and_raise(Twitter::Exceptions::InvalidStatusException)
        Birthday.post_birthdays Date.new(2013, 1, 10)
      end
    end
  end
end
