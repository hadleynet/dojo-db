require 'test_helper'

class AttendancesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @attendance = attendances(:one)
    @user = User.find_by(email: 'foo@bar.org')
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get form" do
    get :form
    assert_response :success
  end

  test "should get attendances" do
    get :attendance
    assert_response :success
  end
end
