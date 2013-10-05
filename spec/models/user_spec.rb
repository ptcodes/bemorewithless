require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  describe "Generating new username" do

    before :all do
      user.stubs(:rand).returns(5)
    end

    it "should return username" do
      user.send(:safe_username, user.username).should == 'johnsmith'
    end

    it "should generate new username if it's reserved" do
      user.username = '500'
      user.send(:safe_username, user.username).should == 'john5'
    end

    it 'should generate new username if user exists with such username' do
      existing_user = User.create(email: 'john@example.org', username: 'johnsmith', password: 'qwerty')
      user.first_name = 'Paul'
      user.send(:safe_username, user.username).should == 'paul5'
    end

    it "should generate username with a random number if user doesn't have first_name" do
      existing_user = User.create(email: 'john@example.org', username: 'johnsmith', password: 'qwerty')
      user.first_name = ''
      user.send(:safe_username, user.username).should == '5'
    end

    it "should generate username with a random number if username is empty" do
      user.username = ''
      user.send(:safe_username, user.username).should == '5'
    end

  end

end
