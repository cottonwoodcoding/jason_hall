$ ->
  $(document).on 'change', '#partner_type', ->
    val = $(@).find('option:selected').val()
    if val == 'new'
      $('.new-partner-type').removeClass('hidden')
    else
      $('.new-partner-type').addClass('hidden')

  $(document).on 'click', '.partner-link a', ->
    $('.partner-link a').removeClass('underline')
    $(@).addClass('underline')
    el = $(@)
    $.ajax '/category',
      type: 'GET'
      data:
        id: $(el).attr('data-id')
      success: (data) ->
        $('.partners-sub').html(data)
