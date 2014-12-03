$ ->
  updateInfo = (element, type, message) ->
   html = "<div class='alert alert-#{type} fade in' role='alert'><h4 class='center'>#{message}</h4></div>"
   $(element).html(html)
   window.setTimeout (->
     element.children('.alert').fadeTo(500, 0).slideUp 500, ->
       $(this).remove()
     ), 3000

  $(document).on 'click', '#add_process', (e) ->
    e.preventDefault()
    $('.new-process').slideToggle()

  $(document).on 'click', '.process-down, .process-up', (e) ->
    unless $(@).hasClass('inactive')
      current_order = $(@).closest('.panel-heading').attr('data-order')
      if $(@).hasClass('process-down')
        next = (parseInt(current_order) + 1).toString()
      else
        next = (parseInt(current_order) - 1).toString()
      swap = $('.process-panel-heading').parent().find("[data-order='#{next}']")
      $(@).closest('.process-panel-heading').attr('data-order', $(swap).attr('data-order'))
      swap_order = $(swap).attr('data-order')
      $(swap).attr('data-order', current_order)
      elements = {
        bottom_id: $(swap).attr('id').split('process_')[1],
        bottom_new_order: current_order,
        top_id: $(@).parent().parent().parent().attr('id').split('process_')[1],
        top_new_order: swap_order
      }
      $.ajax '/resources/swap',
        type: 'POST'
        data:
          elements: elements
        success: (data) ->
          $('.loan-process').html(data)

  $(document).on 'submit', '#new_process_form', (e) ->
    input = $('#step_name').val().trim()
    if input == ''
      e.preventDefault()
      updateInfo($('#alert'), 'danger', "Step title can't be blank")
    else if $('#step_description').val() == ''
      e.preventDefault()
      updateInfo($('#alert'), 'danger', "Step description can't be blank")

  $(document).on 'click', '.edit-process', (e) ->
    id = $(@).closest('.panel-heading').attr('id').split('process_')[1]
    name = $(@).closest('.panel-title').text().trim().split(': ')[1]
    description = $(@).closest('.panel').find('.panel-body').text().trim()
    $('#edit_process_id').val(id)
    $('#edit_step_name').val(name)
    $('#edit_step_description').val(description)

  $('#edit_process_form').on 'submit', (e) ->
    input = $('#edit_step_name').val().trim()
    if input == ''
      e.preventDefault()
      updateInfo($('#edit_process_modal_error'), 'danger', "Step name can't be blank")
    else if $('#edit_step_description').val() == ''
      e.preventDefault()
      updateInfo($('#edit_process_modal_error'), 'danger', "Step description can't be blank")
    else
      submit = true
      panels = $('.process-panel-heading h4')
      for p in panels
        current_id = $(p).parent().attr('id').split('process_')[1]
        unless current_id == $('#edit_process_id')
          submit = false if $(p).text().trim().split(': ')[1] == input
      unless submit
        e.preventDefault()
        updateInfo($('#edit_process_modal_error'), 'danger', "Step name must be unique")

  $(document).on 'click', '.approve-comment', (e) ->
    e.preventDefault()
    id = $(@).parent().attr('data-comment-id')
    el = $(@)
    $.ajax '/blog/approve_comment',
      type: 'POST'
      data:
        id: id
      success: (data) ->
        el.addClass('hidden')
      error: ->
        el.removeClass('hidden')


  $(document).on 'click', '.remove-comment', (e) ->
    e.preventDefault()
    id = $(@).parent().attr('data-comment-id')
    el = $(@)
    $.ajax '/blog/delete_comment',
      type: 'POST'
      data:
        id: id
      success: (data) ->
        el.closest('.main-comment-container').remove()
