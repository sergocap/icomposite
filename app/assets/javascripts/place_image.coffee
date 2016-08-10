@init_place_image_load = ->

  $('.place_image_button').on 'click', ->
    $('.place_image_load_button').click()

  preview = $('.js-place_image_upload')

  $('.place_image_load_button').on 'change', (e) ->
    file = $(this).prop('files')[0]
    if file.type.split('/')[0] == 'image'
      reader = new FileReader()
      reader.onload = (e) ->
        $('.place_image_edit_wrapper')[0].style.display = 'block'
        preview.attr('src', e.target.result)
      reader.readAsDataURL(file)
    else
      $('.place_image_edit_wrapper')[0].style.display = 'none'
      alert 'Выберите картинку'

@init_image_crop = ->
  preview = $('.js-image_crop')
  ratiow = preview.data().ratiow
  ratioh = preview.data().ratioh
  showCoords = (c) ->
    $('#place_crop_x').val(c.x)
    $('#place_crop_y').val(c.y)
    $('#place_crop_width').val(c.w)
    $('#place_crop_height').val(c.h)

  $('.js-image_crop').Jcrop
    aspectRatio: ratiow / ratioh
    onChange: showCoords
    onSelect: showCoords
    allowSelect: false
    setSelect: [0, 0, ratiow * 100, ratioh * 100]

@init_place_color_edit = ->
  img = $('.place_image')[0]
  canvas = $('.canvas')
  context = canvas[0].getContext('2d')
  img.onload = ->
    canvas.attr('width', img.width)
    canvas.attr('height', img.height)
    context.drawImage(img, 0, 0)
