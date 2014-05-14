# encoding: UTF-8

module UsedVacationsHelper
  def common_title_action_name
    "common.title.#{action_name_for_present}"
  end

  def action_name_for_present
    if ['new', 'create'].include? action_name
      'new'
    elsif ['edit', 'update'].include? action_name
      'edit'
    else
      action_name
    end
  end
end