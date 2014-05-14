class DayworkerTax < ActiveRecord::Base
  belongs_to :employee

  include PaymentRequestable
  include ActiveRecord::Extensions::TextSearch

  class << self
    def search(text, request_status)
      text = "%#{text}%"
      query = <<-QUERY
        employees.juminno LIKE ? OR dayworker_taxes.reason LIKE ? OR #{Contact.search_by_name_query}
      QUERY

      joins(employee: {person: :contact}).includes(:payment_request)
        .where(query, text, text, text)
        .search_by_request_status(request_status)
    end
  end

  def bankbook
    bankbook = employee.bankbook rescue nil
  end

  def generate_payment_request
    PaymentRequest.generate_payment_request(self, bankbook, pay_amount)
  end
end