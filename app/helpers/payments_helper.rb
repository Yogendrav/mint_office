module PaymentsHelper
  def next_payment(paid_at)
    return
  end

  def payment_step
    pay_start_date = DateTime.parse_by_params(params[:payments], :join_at).to_date
    pay_end_date = DateTime.parse_by_params(params[:payments], :pay_finish).to_date
    pay_base_day = current_company.pay_basic_date
    amount = params[:payments][:amount].to_i
  
    loop_start = pay_start_date.beginning_of_month
    previous_pay_base_date = nil
    while loop_start <= pay_end_date
      t_pay_base_day = [loop_start.end_of_month.day,pay_base_day].min
      pay_base_date = loop_start.change(day: t_pay_base_day)
      
      # 이달의 지급 사작
      previous_pay_base_date = pay_base_date - 1.month if previous_pay_base_date.nil?
      pay_start_date_of_month = [previous_pay_base_date + 1.day,pay_start_date].max
      # 이달의 지급 종료일
      pay_end_date_of_month = (pay_base_date > pay_end_date ? pay_end_date : pay_base_date)

      if pay_base_date >= pay_start_date_of_month
        working_day = Holiday.working_days(pay_start_date_of_month,pay_end_date_of_month)
        working_month = Holiday.working_days(pay_end_date_of_month - 1.month + 1.day,pay_end_date_of_month)

        yield pay_start_date_of_month, pay_end_date_of_month, (amount * working_day/working_month.to_f).to_i
      end
      previous_pay_base_date = pay_base_date
      loop_start = loop_start.next_month.beginning_of_month
    end
  end
end