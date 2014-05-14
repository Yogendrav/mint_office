# encoding: utf-8
Given(/^there are half\-day vacations on this month$/) do
  #Person.current_person = FactoryGirl.create(:person)
  FactoryGirl.create(:account)
  visit "/test/sessions?person_id=1"
  @full_day = FactoryGirl.create(:used_vacation)
  @half_day = FactoryGirl.create(:used_vacation, :with_half_day)
end

When(/^I visit main page$/) do
  #visit "/test/sessions?person_id=#{Person.current_person.id}"
  visit root_path
end

Then(/^I should distinguish half\-day vacation from full\-day vacations$/) do
  # chech half-day as half-day
  # check full-day as full-day
  #assert(page.has_content?('사용자계정'))
  page.should have_content @full_day.type.title
  page.should have_content I18n.t ("used_vacations."+@half_day.from_half)
end