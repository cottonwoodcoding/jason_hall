$ ->
  $('.rectangle').hover (->
    $(@).addClass('expand-rectangle')
    $(@).addClass('pointer')
    $(@).siblings('.triangle-l').addClass('expand-triangle')
  ), ->
    $(@).removeClass('expand-rectangle')
    $(@).siblings('.triangle-l').removeClass('expand-triangle')

