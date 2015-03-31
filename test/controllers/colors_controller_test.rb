require 'test_helper'

class ColorsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @color = colors(:purple)
    @user = User.find_by(email: 'foo@bar.org')
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:colors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create color" do
    assert_difference('Color.count') do
      post :create, color: { description: @color.description }
    end
    assert_redirected_to colors_path()
  end

  test "should show color" do
    get :show, id: @color
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @color
    assert_response :success
  end

  test "should update color" do
    patch :update, id: @color, color: { id: @color.id, description: "New" }
    assert_redirected_to colors_path()
    updated = Color.find(@color.id)
    assert_equal("New", updated.description)
  end

  test "should destroy color" do
    assert_difference('Color.count', -1) do
      delete :destroy, id: @color
    end
    assert_redirected_to colors_path
  end
end
