$ ->
  updateInfo = (type, message) ->
    html = "<div class='alert alert-#{type} fade in' role='alert'><h4 class='center'>#{message}</h4></div>"
    $('#review_alerts').html(html)
    window.setTimeout (->
      $('#review_alerts').children('.alert').fadeTo(500, 0).slideUp 500, ->
      $(this).remove()
    ), 3000

  $(document).on 'click', '.add-video', ->
    $('#add_videos_modal').modal('show')

  $('#new_text_review').on 'click', (e) ->
    e.preventDefault()
    $('#text_review_form').toggleClass('hidden')

  $('#text_review_form').on 'submit', (e) ->
    name = $('#reviewer_name')
    review = $('#review')
    if name.val().trim() == ''
      e.preventDefault()
      updateInfo('danger', 'Please provide a name')
    else if review.val().trim() == ''
      e.preventDefault()
      updateInfo('danger', 'Please provide a review')

  $('.vid-thumb').on 'click', (e) ->
    key = $(@).children().attr('vid-key')
    frame = $('iframe')
    frame[0].contentWindow.location.href = "https://www.youtube.com/embed/#{key}"

  $(document).ready ->
    if (window.location.href.indexOf('review') > -1)
      $('#carousel').elastislide(minItems: 3)

  $(document).on 'click', '.trash-item i', ->
    choice = confirm "Really delete this video?"
    if choice
      $.ajax '/delete_video',
        type: 'POST'
        data:
          key: $(@).attr('data-key')
        success: ->
          window.location.reload()
