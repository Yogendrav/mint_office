require 'test_helper'

class EmployeeClassificationsControllerTest < ActionController::TestCase
  setup do
    @employee_classification = employee_classifications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_classifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee_classification" do
    assert_difference('EmployeeClassification.count') do
      post :create, employee_classification: { name: @employee_classification.name }
    end

    assert_redirected_to employee_classification_path(assigns(:employee_classification))
  end

  test "should show employee_classification" do
    get :show, id: @employee_classification
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee_classification
    assert_response :success
  end

  test "should update employee_classification" do
    put :update, id: @employee_classification, employee_classification: { name: @employee_classification.name }
    assert_redirected_to employee_classification_path(assigns(:employee_classification))
  end

  test "should destroy employee_classification" do
    assert_difference('EmployeeClassification.count', -1) do
      delete :destroy, id: @employee_classification
    end

    assert_redirected_to employee_classifications_path
  end
end
