$ ->
  $('.amortization_select').change ->
    $amortizationContent = $('.amortization_content')

    $.ajax '/amortization_content',
      type: 'GET'
      data: {'type' : $(@).find('option:selected').attr('value')}
      success: (data) ->
        $amortizationContent.html(data)
        $('.amortization_calculation_content').hide()
      error: (data) ->
        alert('Something went wrong. Please try again or contact us.')

  $('.amortization_form').submit (e) ->
    e.preventDefault()
    $button = $('amortization_calculation_button')
    $button.prop('disabled', true)
    $button.html('Calculating...')
    $.ajax '/calculate_amortization',
      type: 'POST'
      data: $('.amortization_form').serializeArray()
      success: (data) ->
        $amortizationCalculationContent = $('.amortization_calculation_content')
        $amortizationCalculationContent.html(data)
        $amortizationCalculationContent.show()
        $button.prop('disabled', false)
        $button.html('Calculate')
      error: (data) ->
        $button.prop('disabled', false)
        $button.html('Calculate')
        alert('Something went wrong while calculating your amortization. Please try again or contact us.')

  $('#inputBorrowed').bind 'keypress keyup blur', ->
    loanAmount = parseFloat($(@).val())
    if $(@).val() == ''
      $('#taxes').val('')
      $('#insurance').val('')
    else
      taxes = loanAmount * .007
      ins = loanAmount * .002
      $('#taxes').val(taxes.toFixed(2))
      $('#insurance').val(ins.toFixed(2))
