require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @session = sessions(:one)
    @user = User.find_by(email: 'foo@bar.org')
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create session" do
    assert_difference('Session.count') do
      post :create, session: { am: @session.am, day_of_week: @session.day_of_week, hour: @session.hour, minute: @session.minute, name: @session.name, style_id: @session.style_id }
    end

    assert_redirected_to karate_session_path(assigns(:session))
  end

  test "should show session" do
    get :show, id: @session
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @session
    assert_response :success
  end

  test "should update session" do
    patch :update, id: @session, session: { am: @session.am, day_of_week: @session.day_of_week, hour: @session.hour, minute: @session.minute, name: @session.name, style_id: @session.style_id }
    assert_redirected_to karate_session_path(assigns(:session))
  end

  test "should destroy session" do
    assert_difference('Session.count', -1) do
      delete :destroy, id: @session
    end

    assert_redirected_to karate_sessions_path
  end
end
