# encoding: UTF-8

class EmployeeClassificationsController < ApplicationController
  def index
    @employee_classifications = EmployeeClassification.find(:all, :order => "name")
  end

  def add_employee
    participant_info = params[:participant].split('-')
    participant_type = participant_info.first
    participant_id = participant_info.last

    collection_name  = participant_type.tableize

    @employee_classification = EmployeeClassification.find_by_name(params[:id])
    @participant = participant_type.classify.constantize.find(participant_id)

    if !@participant
      redirect_to @employee_classification, alert: t('controllers.employee_classifications.fail_add')
    elsif @employee_classification.send(collection_name).include?(@participant)
      redirect_to @employee_classification, alert: t('controllers.employee_classifications.already_exist')
    else
      @employee_classification.send(collection_name) << @participant
      redirect_to @employee_classification, notice: t('controllers.employee_classifications.success_add')
    end
  end

  def remove_employee
    model_name  = params[:participant_type].to_s.classify.constantize
    collection_name  = params[:participant_type].to_s.tableize

    @employee_classification = EmployeeClassification.find_by_name(params[:id])
    @participant = model_name.find(params[:participant_id])
    @employee_classification.send(collection_name).delete(@participant)

    redirect_to @employee_classification
  end

  def show
    @employee_classification = EmployeeClassification.find_or_create_by_name(params[:id])
  end

  def new
    @employee_classification = EmployeeClassification.new
  end

  def create
    @employee_classification = EmployeeClassification.new(params[:employee_classification])
    @employee_classification.save!
    redirect_to @employee_classification, notice: t('common.messages.created', :model => EmployeeClassification.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def destroy
    @employee_classification = EmployeeClassification.find(params[:id])
    @employee_classification.destroy
    redirect_to @employee_classification, notice: t('common.messages.destroyed', :model => EmployeeClassification.model_name.human)
  end
end
