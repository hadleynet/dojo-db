require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @person = people(:one)
    @user = User.find_by(email: 'foo@bar.org')
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, person: { active: @person.active, birthdate: @person.birthdate, forename: @person.forename, surname: @person.surname }
    end

    assert_redirected_to person_path(assigns(:person))
  end

  test "should show person" do
    get :show, id: @person
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @person
    assert_response :success
  end

  test "should update person" do
    patch :update, id: @person, person: { active: @person.active, birthdate: @person.birthdate, forename: @person.forename, id: @person.id, surname: @person.surname }
    assert_redirected_to person_path(assigns(:person))
  end

end
