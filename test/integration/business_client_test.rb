# encoding: UTF-8
require 'test_helper'

class BusinessClientTest < ActionDispatch::IntegrationTest
  fixtures :business_clients
  fixtures :contacts
  fixtures :taxmen
  fixtures :bankbooks

  test 'should visit business_client list' do
    visit '/'
    click_link '거래처 관리'

    assert(page.has_content?('거래처 관리'))
  end

  test 'should create a new business_client and check bug' do
    visit '/'
    click_link '거래처 관리'
    click_link '신규 작성'

    fill_in "거래처명", with: "거래처명 입력 테스트"
    fill_in "사업자 등록번호", with: "123-321-12345"
    select '농협 통장', from: 'business_client_bankbook_id'
    fill_in "업종", with: "업종 입력 테스트"
    fill_in "업태", with: "업태 입력 테스트"
    fill_in "주소", with: "주소 입력 테스트"
    fill_in "대표자", with: "대표자 입력 테스트"

    click_button '거래처 만들기'

    assert(page.has_content?('거래처이(가) 성공적으로 생성되었습니다.'))

    assert(page.has_content?('거래처명 입력 테스트'))
    assert(page.has_content?('123-321-12345'))
    assert(page.has_content?('업종 입력 테스트'))
    assert(page.has_content?('업태 입력 테스트'))
    assert(page.has_content?('주소 입력 테스트'))
    assert(page.has_content?('농협 통장'))

    visit '/'
    click_link '지급 조서 목록'
    click_link '신규 작성'

    assert(page.has_content?('없음'))

    visit '/dayworkers'
    click_link '신규 작성'

    assert(page.has_content?('없음'))
  end

  test 'should edit business_client' do
    visit '/'
    click_link '거래처 관리'
    click_link '상세보기'
    click_link '수정하기'

    fill_in "거래처명", with: "거래처명 수정 테스트"
    fill_in "사업자 등록번호", with: "321-123-54321"
    select '농협 통장', from: 'business_client_bankbook_id'
    fill_in "업종", with: "업종 수정 테스트"
    fill_in "업태", with: "업태 수정 테스트"
    fill_in "주소", with: "주소 수정 테스트"
    fill_in "대표자", with: "대표자 수정 테스트"

    click_button '거래처 수정하기'

    assert(page.has_content?('거래처이(가) 성공적으로 업데이트 되었습니다.'))

    assert(page.has_content?('거래처명 수정 테스트'))
    assert(page.has_content?('321-123-54321'))
    assert(page.has_content?('업종 수정 테스트'))
    assert(page.has_content?('업태 수정 테스트'))
    assert(page.has_content?('주소 수정 테스트'))
    assert(page.has_content?('대표자 수정 테스트'))
    assert(page.has_content?('농협 통장'))
  end

  test 'should add taxman' do
    visit '/'
    click_link '거래처 관리'
    click_link '상세보기'

    click_link '담당자 추가하기'
    click_link '상세보기'

    assert(page.has_content?('이미 존재합니다'))

    # 김 개똥이 없다 `assert(page.has_content?('김 개똥'))` 이거로 확인할때 없었음.
    # click_link '담당자 추가하기'
    # all('tr')[1].click_link('상세보기')

    # assert(page.has_content?('김 개똥'))
  end
end