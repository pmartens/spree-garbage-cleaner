require 'spec_helper'

describe Spree::User do
  it "has a garbage finder method" do
    created_on = Spree::GarbageCleaner::Config.cleanup_days_interval

    user_one = Spree::User.anonymous!
    user_two = Spree::User.anonymous!
    user_three = Factory(:user)

     user_one.update_column(:created_at, (created_on+rand(10)).days.ago)
     user_two.update_column(:created_at, (created_on+rand(10)).days.ago)

    Spree::User.garbage.should == [user_one, user_two]
  end

  it "has a method that tells if order is garbage" do
    user = Factory.build(:user)
    user.should respond_to(:garbage?)
  end

  it "is garbage if anonymous and past cleanup_days_interval" do
    created_on = Spree::GarbageCleaner::Config.cleanup_days_interval
    user = Spree::User.anonymous!
    user.update_column(:created_at, created_on.days.ago)
    user.garbage?.should be_true
  end

  it "is not garbage if anonymous and not past cleanup_days_interval" do
    created_on = Spree::GarbageCleaner::Config.cleanup_days_interval
    user = Spree::User.anonymous!
    user.update_column(:created_at, (created_on-1).days.ago)
    user.garbage?.should be_false
  end

  it "is not garbage if not anonymous and past cleanup_days_interval" do
    created_on = Spree::GarbageCleaner::Config.cleanup_days_interval
    user = Factory.build(:user, :created_at => created_on.days.ago)
    user.garbage?.should be_false
  end

  it "is not garbage if not anonymous and not past cleanup_days_interval" do
    created_on = Spree::GarbageCleaner::Config.cleanup_days_interval
    user = Factory.build(:user)
    user.garbage?.should be_false
  end
end