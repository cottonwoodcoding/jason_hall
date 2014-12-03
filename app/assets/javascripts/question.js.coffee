$ ->
  updateInfo = (element, type, message) ->
   html = "<div class='alert alert-#{type} fade in' role='alert'><h4 class='center'>#{message}</h4></div>"
   $(element).html(html)
   window.setTimeout (->
     element.children('.alert').fadeTo(500, 0).slideUp 500, ->
       $(this).remove()
     ), 3000

  $(document).on 'click', '#add_question', (e) ->
    e.preventDefault()
    $('.new-question').slideToggle()

  $(document).on 'click', '.question-down, .question-up', (e) ->
    unless $(@).hasClass('inactive')
      current_order = $(@).closest('.panel-heading').attr('data-order')
      if $(@).hasClass('question-down')
        next = (parseInt(current_order) + 1).toString()
      else
        next = (parseInt(current_order) - 1).toString()
      swap = $('.question-panel-heading').parent().find("[data-order='#{next}']")
      $(@).closest('.question-panel-heading').attr('data-order', $(swap).attr('data-order'))
      swap_order = $(swap).attr('data-order')
      $(swap).attr('data-order', current_order)
      elements = {
        bottom_id: $(swap).attr('id').split('faq_')[1],
        bottom_new_order: current_order,
        top_id: $(@).parent().parent().parent().attr('id').split('faq_')[1],
        top_new_order: swap_order
      }
      $.ajax '/resources/swap_question',
        type: 'POST'
        data:
          elements: elements
        success: (data) ->
          $('.questions').html(data)

  $(document).on 'submit', '#new_question_form', (e) ->
    input = $('#question').val().trim()
    if input == ''
      e.preventDefault()
      updateInfo($('#alert'), 'danger', "Question can't be blank")
    else if $('#answer').val() == ''
      e.preventDefault()
      updateInfo($('#alert'), 'danger', "Answer can't be blank")

  $(document).on 'click', '.edit-question', (e) ->
    id = $(@).closest('.panel-heading').attr('id').split('faq_')[1]
    name = $(@).closest('.panel-title').text().trim().split(': ')[1]
    description = $(@).closest('.panel').find('.panel-body').text().trim()
    $('#edit_question_id').val(id)
    $('#edit_question').val(name)
    $('#edit_answer').val(description)

  $('#edit_question_form').on 'submit', (e) ->
    input = $('#edit_question').val().trim()
    if input == ''
      e.preventDefault()
      updateInfo($('#edit_question_modal_error'), 'danger', "Question can't be blank")
    else if $('#edit_answer').val() == ''
      e.preventDefault()
      updateInfo($('#edit_question_modal_error'), 'danger', "Answer can't be blank")
    else
      submit = true
      panels = $('.question-panel-heading h4')
      for p in panels
        current_id = $(p).parent().attr('id').split('faq_')[1]
        unless current_id == $('#edit_question_id')
          submit = false if $(p).text().trim() == input
      unless submit
        e.preventDefault()
        updateInfo($('#edit_question_modal_error'), 'danger', "Question must be unique")
