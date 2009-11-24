require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "authenticate should return user if password is correct" do
    assert_equal users(:admin), User.authenticate("admin", "testing")
  end

  test "authenticate should return nil if user_name is incorrect" do
    assert_nil User.authenticate("bob", "testing")
  end

  test "authenticate should return nil if password is incorrect" do
    assert_nil User.authenticate("admin", "test")
  end

  test "creating new user should set salt and hash password" do
    user = User.create(:login    => "fred",
                       :password => "flintstone",
                       :email    => "fred@photos.com")
    assert !user.password_hash.blank?
    assert !user.password_salt.blank?
    assert_equal user, User.authenticate("fred", "flintstone")
  end

  test "updating user's password should change salt and hash new password" do
    old_salt = users(:admin).password_salt
    old_password_hash = users(:admin).password_hash

    users(:admin).update_attribute :password, "new-password"
    assert_not_equal users(:admin).password_salt, old_salt
    assert_not_equal users(:admin).password_hash, old_password_hash

    assert_nil User.authenticate("admin", "testing")
    assert_equal users(:admin), User.authenticate("admin", "new-password")
  end

  test "creating new user with duplicate user name should fail" do
    begin
      User.create!(:login    => "admin",
                   :email    => "admin@photos.com", 
                   :password => "admin")
    rescue ActiveRecord::RecordInvalid => error
      assert error.record.errors.on(:login)
    else
      flunk "expected create to fail"
    end
  end

end