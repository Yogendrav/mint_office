# encoding: UTF-8
require 'test_helper'

class DayWorkerTest < ActionDispatch::IntegrationTest
  fixtures :people, :contacts, :dayworker_taxes, :dayworkers

  test 'should visit dayworker_taxes list' do
    visit '/dayworker_taxes'

    assert(page.has_content?('김 관리'))
    assert(page.has_content?('111111-1111111'))
    assert(page.has_content?('30,000'))
    assert(page.has_content?('payment'))
  end

  test 'should show dayworker_taxes' do
    visit '/dayworker_taxes'
    click_link '상세보기'
    
    assert(page.has_content?('김 관리'))
    assert(page.has_content?('111111-1111111'))
    assert(page.has_content?('30,000'))
    assert(page.has_content?('payment'))
  end

  test 'should create a new dayworker_taxes' do
    visit '/dayworker_taxes'
    click_link '신규 작성'

    fill_in '사유', with: 'Bonus'
    fill_in '금액', with: '100000'

    click_button '생성'

    assert(page.has_content?('Bonus'))
    assert(page.has_content?('100,000'))
  end

  test 'should edit dayworker_taxes' do
    visit '/dayworker_taxes'
    click_link '상세보기'
    click_link '수정하기'

    fill_in '사유', with: 'Incentive'
    fill_in '금액', with: '1000000'

    click_button '수정'

    assert(page.has_content?('Incentive'))
    assert(page.has_content?('1,000,000'))
  end  
end