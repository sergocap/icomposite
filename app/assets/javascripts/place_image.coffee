@init_place_image_load = ->

  init_image_crop()

  $('.place_image_button').on 'click', ->
    $('.place_image_load_button').click()

  preview = $('.js-place_image_upload')

  $('.place_image_load_button').on 'change', (e) ->
    file = $(this).prop('files')[0]
    if file.type.split('/')[0] == 'image'
      reader = new FileReader()
      reader.onload = (e) ->
        preview.attr('src', e.target.result)
        $('.place_image_edit_wrapper')[0].style.display = 'block'
      reader.readAsDataURL(file)
    else
      $('.place_image_edit_wrapper')[0].style.display = 'none'
      alert 'Выберите картинку'

init_image_crop = ->
  showCoords = (c) ->
    console.log c
    $('#place_crop_x').val(c.x)
    $('#place_crop_y').val(c.y)
    $('#place_crop_width').val(c.w)
    $('#place_crop_height').val(c.h)

  $('.js-place_image_upload').Jcrop
    onChange: showCoords
    onSelect: showCoords
