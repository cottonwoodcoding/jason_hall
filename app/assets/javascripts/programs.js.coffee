$ ->
  updateInfo = (element, type, message) ->
    html = "<div class='alert alert-#{type} fade in' role='alert'><h4 class='center'>#{message}</h4></div>"
    $(element).html(html)
    window.setTimeout (->
      element.children('.alert').fadeTo(500, 0).slideUp 500, ->
        $(this).remove()
      ), 3000

  window.onload = ->
    if window.location.pathname == '/resources'
      $('.new-program').hide()
      $('.new-process').hide()
      $('.new-question').hide()

  $(document).on 'click', '#add_program', (e) ->
    e.preventDefault()
    $('.new-program').slideToggle()

  $(document).on 'submit', '#new_program_form', (e) ->
    input = $('#loan_type').val().trim()
    if input == ''
      e.preventDefault()
      updateInfo($('#alert'), 'danger', "Loan type can't be blank")
    else if $('#loan_description').val() == ''
      e.preventDefault()
      updateInfo($('#alert'), "danger", "Description can't be blank")
    else
      submit = true
      panels = $('.panel-heading h4')
      for p in panels
        submit = false if $(p).text().trim() == input
      unless submit
        e.preventDefault()
        updateInfo($('#alert'), 'danger', 'Loan type must be unique')


  $('#edit_program_form').on 'submit', (e) ->
    input = $('#type').val().trim()
    if input == ''
      e.preventDefault()
      updateInfo($('#edit_modal_error'), 'danger', "Loan type can't be blank")
    else if $('#description').val() == ''
      e.preventDefault()
      updateInfo($('#edit_modal_error'), "danger", "Description can't be blank")
    else
      submit = true
      panels = $('.program-panel-heading h4')
      for p in panels
        id = $(p).parent().attr('id').split('program_')[1]
        unless id == $('#edit_id')
          submit = false if $(p).text().trim() == input
      unless submit
        e.preventDefault()
        updateInfo($('#edit_modal_error'), 'danger', 'Loan type must be unique')

  $(document).on 'click', '.edit-program', (e) ->
    id = $(@).parent().parent().parent().attr('id').split('program_')[1]
    name = $(@).parent().parent().text().trim()
    description = $(this).parent().parent().parent().siblings().children().text().trim()
    $('#type').val(name)
    $('#description').val(description)
    $('#edit_id').val(id)
