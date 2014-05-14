require 'test_helper'

class UsedVacationTest < ActiveSupport::TestCase
  fixtures :accounts, :groups_people, :groups
  fixtures :used_vacations

  setup do
    @valid_attributes = {
      vacation_id: 1,
      from: "#{Time.zone.now}",
      to: "#{Time.zone.now}",
      note: "test",
      period: 1
    }
  end

  test "UsedVacation should create used_vacation with valid attributes" do
    used_vacation = UsedVacation.new(@valid_attributes)
    assert used_vacation.valid?
  end

  test "UsedVacation shouldn't create used_vacation with invalid attributes" do
    used_vacation = UsedVacation.new(@valid_attributes)
    used_vacation.period = 0.4

    assert used_vacation.invalid?

    used_vacation = UsedVacation.new(@valid_attributes)
    used_vacation.period = 0.5

    assert used_vacation.valid?

    used_vacation.period = 1.5

    assert used_vacation.valid?

    used_vacation.period = 2.0

    assert used_vacation.valid?
  end

  test "UsedVacation during should retreive correct vacation list" do
    # p "UsedVacation during should retreive correct vacation list"
    Person.current_person = Person.first

    date = Date.today
    far_before_startDate = date
    before_startDate = date += 2
    startDate = date += 2
    betweenDate = date += 2
    betweenDate2 = date += 1
    endDate = date += 2
    after_endDate = date += 5
    far_after_endDate = date += 5

    vacation_type = VacationType.create(title:"test", deductible:true)

    far_before_and_before = UsedVacation.create(from:far_before_startDate, to:before_startDate, note:"1", period:1, type_:vacation_type)
    after_and_far_after = UsedVacation.create(from:after_endDate, to:far_after_endDate, note:"1", period:1, type_:vacation_type)
    before_and_between = UsedVacation.create(from:before_startDate, to:betweenDate, note:"1", period:1, type_:vacation_type)
    between_and_after = UsedVacation.create(from:betweenDate, to:after_endDate, note:"1", period:1, type_:vacation_type)
    between_and_between2 = UsedVacation.create(from:betweenDate, to:betweenDate2, note:"1", period:1, type_:vacation_type)
    before_and_after = UsedVacation.create(from:before_startDate, to:after_endDate, note:"1", period:1, type_:vacation_type)

    assert_equal(UsedVacation.during(startDate..endDate), [before_and_between, between_and_after, between_and_between2, before_and_after])
  end
end