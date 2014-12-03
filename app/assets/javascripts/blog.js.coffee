$ ->
  $('.panel-group').on 'shown.bs.collapse hidden.bs.collapse', (e) ->
    $(e.target).siblings().find('.caret-toggle').toggleClass('fa-caret-down fa-caret-right')

  blogReady = ->
    if (window.location.href.indexOf('/blog') > -1)
      id = $('.blog-container h2').attr('data-post-id')
      $.ajax '/blog/comments',
        type: 'GET'
        data:
          post_id: id
        success: (data) ->
          $('.comments').html(data)

  window.onload = blogReady()

  $(document).ready ->
    $('#edit_blog_editor').html($('#edit_blog_editor').attr('value'))
    if (window.location.href.indexOf('/blog/edit') > -1)
      tinyMCE.init({
        selector: 'textarea#edit_blog_editor'
      })

  $('#new_comment').on 'click', (e) ->
    e.preventDefault()
    $('#new_comment_form').toggleClass('hidden')

 $(document).on 'click', '#anon', (e) ->
   if $(@).is ':checked'
     $('#user_name').val('Anonymous')
     $('#user_name').addClass('disabled')
     $('#user_name').attr('disabled', true)
   else
     $('#user_name').val('')
     $('#user_name').removeClass('disabled')
     $('#user_name').attr('disabled', false)

  $(document).on 'submit', '#new_comment_form', (e) ->
    e.preventDefault()
    values = $(@).serializeArray()
    data = {}
    $.each values, (k, v) =>
      data[v.name] = v.value
    id = $('.blog-container h2').attr('data-post-id')
    data['id'] = id
    $.ajax '/blog/new_comment',
      type: 'POST'
      data:
        comment: data
      success: (data) ->
        $('.comments').html(data)
        $('#new_comment_form').trigger('reset')
        $('#new_comment_form').addClass('hidden')
        $('#user_name').removeClass('disabled')
        $('#user_name').attr('disabled', false)

  $(document).on 'submit', '#new_post_form', (e) ->
    e.preventDefault()
    tinyMCE.triggerSave()
    document.forms[0].submit()


