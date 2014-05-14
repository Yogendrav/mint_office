# # encoding: utf-8
require 'factory_girl'

FactoryGirl.define do
	factory :account do
		sequence(:name) { |n| "name#{n}"}
		password 				"password"
		before(:create) do 
			Company.current_company = FactoryGirl.create(:company)
		end
		after(:create) do |account,evaluator|
			FactoryGirl.create(:employee, person: account.person)
		end
	end
	factory :company do
	end
	factory :employee do
		sequence(:companyno) { |n| n + 100}
		sequence(:juminno)   { |n| "112233-445566#{n}" }
	end
	factory :vacation_type do
		title				"휴가"
		deductible	true
	end
	factory :vacation do
		employee
		from 			{ DateTime.now.beginning_of_year }		
		to 				{ DateTime.now.end_of_year }
		period		10
	end
	factory :used_vacation do
		vacation
		type_				{ FactoryGirl.create(:vacation_type).id }
		from 				{ DateTime.now.beginning_of_week }
		from_half		"AM"
		to 					{ DateTime.now.beginning_of_week }
		to_half			"PM"
		#period			1

		trait :with_half_day do
			to_half			"AM"
		end
	end
end
# FactoryGirl.define do
# 	factory :bank do
#     name   "민트은행"
#     account_number  "742-158800-02-1111"
#     account_holder  "민트기술"
# 	end

# 	factory :brand_shop do
# 		name 		"Tridia"
# 		url     "http://example.com"
# 		description "hello world!"
# 	end

# 	factory :user do
# 		sequence(:login) {|n| "email_#{n}@mintech.kr"}
# 		password  "1234"
# 		password_confirmation  "1234"
# 		sequence(:phone) {|n| "011-0000-#{n}"}
# 		zipcode  "123-123"
# 		address_sido  "서울특별시"
# 		address_gugun  "강남구"
# 		address_dong   "신사동"
# 		address_detail  "우리집"		
# 		supplier
# 	end

# 	factory :supplier do
# 		sequence(:name) {|n| "#{n}am"}
# 		max_purchase_amount		100
# 		price_css_selector 		 "#main_price"
# 		sequence(:phone_number)
# 		delivery_info					"배송정보입니다."
# 		refund_info						"교환 환불 정보입니다."
# 		retailer_info					"판매자 정보입니다."
# 		commission_rate				20
# 		email 								"email@mintech.kr"
# 		after :create do |supplier|
# 			FactoryGirl.create(:delivery_fee, supplier: supplier)
# 		end
# 	end

# 	factory :category do
# 		sequence(:name) {|n| "아동복_#{n}" }
# 	end

# 	factory :device do
# 		user_token		"valid_user"
# 		device_token 	"valid_device"
# 		device_type 	1
# 	end

# 	# factory :coupon do
# 	# 	product
# 	# 	user_token: 'USER_TOKEN'
# 	# 	expire_date Time.now + 3.days
# 	# 	discounted_price 100
# 	# end

# 	factory :product do
# 		supplier
# 		category
# 		sequence(:title) { |n| "상품명_#{n}" }
# 		sequence(:subtitle)	{ |n| "정말 좋은 상품입니다_#{n}" }
# 		sequence(:code) { |n| "code_#{n}" }
# 		price 								 "50000"
# 		description 					 "상품 설명글"			
# 		link_url 							 "http://naver.com"
# 		status								 false
# 		mileage_percentage		 10

# 		trait :with_color_option do
# 			after :create do |product|
# 				FactoryGirl.create :color_option, :product => product
# 			end
# 		end

# 		trait :with_size_option do
# 			after :create do |product|
# 				FactoryGirl.create :size_option, :product => product
# 			end
# 		end

# 		trait :with_options do
# 			with_color_option
# 			with_size_option
# 		end

# 		trait :with_options_and_stocks do
# 			with_options
# 			after :create do |product|
# 				product.sizes.each do |size|
# 					product.colors.each do |color|
# 						FactoryGirl.create(:stock, product_id: product.id, color_option_id: color.id, size_option_id: size.id)
# 					end
# 				end
# 			end
# 		end
# 	end

# 	# factory :purchase_item do
# 	# 	product
# 	# 	color_option
# 	# 	size_option

# 	# 	trait :belongs_to_an_order do |item|
# 	# 		purchase_order
# 	# 	end
# 	# end

# 	factory :color_option do
# 		product
# 		color 	"RED"
# 	end

# 	factory :size_option do
# 		product
# 		size 		"XXL"
# 	end

# 	factory :stock do
# 		product
# 		stock			999
# 		current_stock 998
# 	end

# 	factory :delivery_fee do
# 		supplier
# 		default_fee 5_000
# 		free_delivery_price 30_000
# 	end
# end

