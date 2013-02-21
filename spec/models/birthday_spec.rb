# coding: utf-8

require 'spec_helper'
require 'date'
require 'twitter'

describe Birthday do
  describe "post_birthday" do
    fixtures :birthdays

    before do
      Birthday.stub!(:sleep)
    end

    it "should post birthday comment" do
      Birthday.should_receive(:sleep).with(5).twice
      Twitter.should_receive(:request_for_birthday_bot).with(:update_status, "今日はDiana Rossの誕生日！").ordered
      Twitter.should_receive(:request_for_birthday_bot).with(:update_status, "今日は世界を代表するジャズ・ピアニストである上原ひろみの誕生日！Brainは名盤でしょう。").ordered
      successes, errors = Birthday.post_birthday Date.new(2013, 3, 26)
      successes[0].name_en.should == "Diana Ross"
      successes[1].name_ja.should == "上原ひろみ"
    end

    it "should not post" do
      Twitter.should_not_receive(:request_for_birthday_bot)
      successes, errors = Birthday.post_birthday Date.new(2013, 3, 27)
      successes.should be_empty
      errors.should be_empty
    end

    context "over 140 chars" do
      it "should raise error" do
        Twitter.should_receive(:request_for_birthday_bot).with(:update_status, "今日はMax Roachの誕生日！").ordered
        Twitter.should_receive(:request_for_birthday_bot).with(:update_status, "今日はドイツの生んだ早熟の天才、マイケル・シェンカーの誕生日！").ordered.and_raise(Twitter::Exceptions::InvalidStatusException)
        successes, errors = Birthday.post_birthday Date.new(2013, 1, 10)
        successes[0].name_en.should == "Max Roach"
        errors[0].name_ja.should == "マイケル・シェンカー"
      end
    end
  end
end
