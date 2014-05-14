# encoding: UTF-8
module EmployeeClassificationsHelper
  def options_for_occupational_group_select
    occupational_groups = OccupationalGroup.all.map{|group| ["[직군] #{group.name}", 'occupational_group-' + group.id.to_s]}

    options_for_select(occupational_groups)
  end

  def employee_classification_links
    EmployeeClassification.applied_controller_list.map do |name|
      link_to t("#{name}.index.title"), employee_classification_path(name.to_sym)
    end
  end
end
