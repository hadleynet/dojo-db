require 'test_helper'

class RanksControllerTest < ActionController::TestCase
  setup do
    @rank = ranks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ranks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rank" do
    assert_difference('Rank.count') do
      post :create, rank: { active: @rank.active, belt_color: @rank.belt_color, class_delta: @rank.class_delta, id: @rank.id, name: @rank.name, next_rank_test: @rank.next_rank_test, order: @rank.order, stripe_color: @rank.stripe_color, stripe_count: @rank.stripe_count, translation: @rank.translation }
    end

    assert_redirected_to rank_path(assigns(:rank))
  end

  test "should show rank" do
    get :show, id: @rank
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rank
    assert_response :success
  end

  test "should update rank" do
    patch :update, id: @rank, rank: { active: @rank.active, belt_color: @rank.belt_color, class_delta: @rank.class_delta, id: @rank.id, name: @rank.name, next_rank_test: @rank.next_rank_test, order: @rank.order, stripe_color: @rank.stripe_color, stripe_count: @rank.stripe_count, translation: @rank.translation }
    assert_redirected_to rank_path(assigns(:rank))
  end

  test "should destroy rank" do
    assert_difference('Rank.count', -1) do
      delete :destroy, id: @rank
    end

    assert_redirected_to ranks_path
  end
end
