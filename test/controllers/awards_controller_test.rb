require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @award = awards(:one)
    @user = User.find_by(email: 'foo@bar.org')
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:awards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create award" do
    assert_difference('Award.count') do
      post :create, award: { date: @award.date.strftime('%m/%d/%Y'), person_id: @award.person_id, rank_id: @award.rank_id }
    end

    assert_redirected_to people_path
  end

  test "should show award" do
    get :show, id: @award
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @award
    assert_response :success
  end

  test "should update award" do
    patch :update, id: @award, award: { date: @award.date.strftime('%m/%d/%Y'), person_id: @award.person_id, rank_id: @award.rank_id }
    assert_redirected_to award_path(assigns(:award))
  end

  test "should destroy award" do
    assert_difference('Award.count', -1) do
      delete :destroy, id: @award
    end

    assert_redirected_to awards_path
  end
end
