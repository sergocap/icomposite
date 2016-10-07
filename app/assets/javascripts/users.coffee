@init_avatar_image_load = ->
  $('.avatar_select_button').on 'click', ->
    $('.avatar_image_input').click()
  preview = $('.js-avatar_upload')
  $('.avatar_image_input').on 'change', (e) ->
    file = $(this).prop('files')[0]
    extension = file.name.split('.')[1]
    if extension == "gif" || extension == "png" || extension == "bmp" || extension == "jpeg" || extension == "jpg"
      reader = new FileReader()
      reader.onload = (e) ->
        preview.attr('src', e.target.result)
      reader.readAsDataURL(file)


