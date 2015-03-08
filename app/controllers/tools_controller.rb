class ToolsController < ApplicationController
  include Finance

  def index
  end

  def calculate_amortization
    is_variable = false
    rate = Rate.new((params[:apr].to_f / 100).round(4), :apr, :duration => (params[:duration].to_i * 12))
    amortization = Amortization.new(params[:amount], rate)
    taxes = params[:taxes].blank? ? 0 : (params[:taxes].to_i / 12)
    insurance = params[:insurance].blank? ? 0 : (params[:insurance].to_i / 12)
    @amortization = amortize_payments(amortization)
    render(partial: 'amortization_data', locals: {amortization: amortization, is_variable: is_variable, taxes: taxes, insurance: insurance})
  end

  def amortization_content
    render(partial: 'fixed_content')
  end

    private

    def amortize_payments(loan)
      payment = loan.payment.to_f
      principal = 0
      interest = 0
      payments = []
      loan.interest.each_with_index do |value, i|
        i = i + 1
        interest += value.to_f
        principal += (-payment - value.to_f)
        if i % 12 == 0
          payments << {interest: interest.round(2), principal: principal.round(2)}
          interest = 0
          principal = 0
        end
      end
      payments
    end
end
