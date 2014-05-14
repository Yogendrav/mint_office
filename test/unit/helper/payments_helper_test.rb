# encoding: utf-8

require File.dirname(__FILE__) + "/../../test_helper"
#require 'action_view/test_case'

class PaymentsHelperTest < ActionView::TestCase
	attr_accessor :payments
	def test_pay_basic_date_31
		set_payments(31, 2013, 4, 15, 2013, 6, 14, 0)

		assert_before_after = [
			[Date.new(2013,4,15),Date.new(2013,4,30)],
			[Date.new(2013,5,1),Date.new(2013,5,31)],
			[Date.new(2013,6,1),Date.new(2013,6,14)]
		]
		do_payment_step(assert_before_after)
	end

	def test_pay_basic_date_2_28
		set_payments(31, 2013, 2, 28, 2013, 3, 1, 0)

		assert_before_after = [
			[Date.new(2013,2,28),Date.new(2013,2,28)],
			[Date.new(2013,3,1),Date.new(2013,3,1)]
		]
		do_payment_step(assert_before_after)
	end

	def test_pay_basic_date_3_1
		set_payments(1, 2013, 2, 28, 2013, 3, 1, 0)

		assert_before_after = [
			[Date.new(2013,2,28),Date.new(2013,3,1)]
		]
		do_payment_step(assert_before_after)
	end

	def test_pay_basic_date_3_1_4_1
		set_payments(1, 2013, 3, 1, 2013, 4, 1, 0)

		assert_before_after = [
			[Date.new(2013,3,1),Date.new(2013,3,1)],
			[Date.new(2013,3,2),Date.new(2013,4,1)]
		]
		do_payment_step(assert_before_after)
	end

	def test_pay_basic_date_3_2_4_1
		set_payments(1, 2013, 3, 2, 2013, 4, 1, 0)

		assert_before_after = [
			[Date.new(2013,3,2),Date.new(2013,4,1)]
		]
		do_payment_step(assert_before_after)
	end

	def test_pay_basic_date_1_30_3_1
		set_payments(28, 2013, 1, 29, 2013, 3, 1, 0)

		assert_before_after = [
			[Date.new(2013,1,29),Date.new(2013,2,28)],
			[Date.new(2013,3,1),Date.new(2013,3,1)]
		]
		do_payment_step(assert_before_after)
	end

	def test_pay_basic_date_2_10_4_10
		set_payments(15, 2013, 2, 10, 2013, 4, 10, 0)

		assert_before_after = [
			[Date.new(2013,2,10),Date.new(2013,2,15)],
			[Date.new(2013,2,16),Date.new(2013,3,15)],
			[Date.new(2013,3,16),Date.new(2013,4,10)]
		]
		do_payment_step(assert_before_after)
	end

	def set_payments(pay_basic_date,y1,m1,d1,y2,m2,d2,amount)
		CurrentCompany.pay_basic_date = pay_basic_date
		self.payments = {
			"join_at(1i)" => y1, 
			"join_at(2i)" => m1,
			"join_at(3i)" => d1,
			"pay_finish(1i)" => y2,
			"pay_finish(2i)" => m2,
			"pay_finish(3i)" => d2,
			amount: amount
		}
	end

	def do_payment_step (before_after)
		i = 0
		payment_step do |before,after,amount|
			assert_equal before, before_after[i][0]
			assert_equal after, before_after[i][1]
			i += 1
		end
		assert_equal before_after.length, i
	end

	def params
		{payments: self.payments}
	end

	class CurrentCompany
		class << self
			attr_accessor :pay_basic_date
		end
		def pay_basic_date
			CurrentCompany.pay_basic_date
		end
	end

	def current_company
		CurrentCompany.new
	end
end