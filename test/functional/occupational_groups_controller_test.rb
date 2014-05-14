require 'test_helper'

class OccupationalGroupsControllerTest < ActionController::TestCase
  setup do
    @occupational_group = occupational_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:occupational_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create occupational_group" do
    assert_difference('OccupationalGroup.count') do
      post :create, occupational_group: { name: @occupational_group.name }
    end

    assert_redirected_to occupational_group_path(assigns(:occupational_group))
  end

  test "should show occupational_group" do
    get :show, id: @occupational_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @occupational_group
    assert_response :success
  end

  test "should update occupational_group" do
    put :update, id: @occupational_group, occupational_group: { name: @occupational_group.name }
    assert_redirected_to occupational_group_path(assigns(:occupational_group))
  end

  test "should destroy occupational_group" do
    assert_difference('OccupationalGroup.count', -1) do
      delete :destroy, id: @occupational_group
    end

    assert_redirected_to occupational_groups_path
  end
end
