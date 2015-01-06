class ToolsController < ApplicationController
  include Finance

  def index
  end

  def calculate_amortization
    is_variable = false
    if params[:type] == 'fixed'
      rate = Rate.new((params[:apr].to_f / 100).round(4), :apr, :duration => (params[:duration].to_i * 12))
      amortization = Amortization.new(params[:amount], rate)
    else
      is_variable = true
      values = []
      duration = params[:duration].to_i
      occurrence = params[:occurrence].to_i
      apr = (params[:apr].to_f / 100).round(4)
      duration.times.each do |num|
        if num % occurrence == 0
          if num == 0
            values << apr
          else
            apr = (apr + params[:percent_increase].to_f / 100).round(4)
            values << apr
          end
        end
      end
      rates = values.collect { |value| Rate.new(value, :apr, :duration => (occurrence  * 12))}
      amortization = Amortization.new(params[:amount], *rates)
    end
    render(partial: 'amortization_data', locals: {amortization: amortization, is_variable: is_variable})
  end

  def amortization_content
    params[:type] == 'fixed' ? render(partial: 'fixed_content') : render(partial: 'variable_content')
  end
end
