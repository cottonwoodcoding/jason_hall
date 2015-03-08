$ ->
  $('.circle-reveal').on 'mouseenter mouseleave', ->
    $(@).find('.circle').slideToggle()
    $(@).find('.reveal').toggleClass('hide')
