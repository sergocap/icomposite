@init_place_image_load = ->
  $('.place_image_button').on 'click', ->
    $('.place_image_load_button').click()

  preview = $('.js-place_image_upload')

  $('.place_image_load_button').on 'change', (e) ->
    file = $(this).prop('files')[0]
    if file.type.split('/')[0] == 'image'
      reader = new FileReader()
      reader.onload = (e) ->
        $('.go_crop_with_color').click()
      reader.readAsDataURL(file)
    else
      $('.js-place_image_upload')[0].style.display = 'none'
      alert 'Выберите картинку'

@init_image_crop = ->
  preview = $('.js-image_crop')
  ratiow = preview.data().ratiow
  ratioh = preview.data().ratioh
  showCoords = (c) ->
    set_crop_preview(c)
    $('#place_crop_x').val(c.x)
    $('#place_crop_y').val(c.y)
    $('#place_crop_width').val(c.w)
    $('#place_crop_height').val(c.h)

  $('.js-image_crop').Jcrop
    aspectRatio: ratiow / ratioh
    onChange: showCoords
    onSelect: showCoords
    setSelect: [0, 0, ratiow * 10, ratioh * 10]

@init_place_color_edit = ->
  $('#to_default_button').on 'click', ->
    $('.filter_r').attr('slope', 1)
    $('.filter_g').attr('slope', 1)
    $('.filter_b').attr('slope', 1)
    $('#r_component').attr('value', 1)
    $('#g_component').attr('value', 1)
    $('#b_component').attr('value', 1)

set_crop_preview = (c) ->
  preview_wrapper = $('.crop_preview_wrapper')
  preview_img = $('.js-place_preview_image')
  cropping_image = $('.js-image_crop')
  k = preview_wrapper.data().w / c.w
  w2 = cropping_image[0].width * k
  h2 = cropping_image[0].height * k
  x2 = c.x * k
  y2 = c.y * k

  preview_img.css
    width: Math.round(w2) + 'px'
    height: Math.round(h2) + 'px'
    marginLeft: '-' + Math.round(x2) + 'px'
    marginTop: '-' + Math.round(y2) + 'px'
  true

set_preview = ->
  preview_wrapper = $('.preview_wrapper')
  preview_wrapper[0].style.display = 'inline'
  preview_img = $('.js-place_preview_image')
  place_img = $('.js-place_image_upload')
  preview_img.attr('src', place_img.attr('src'))
  w = preview_wrapper.data().w
  h = preview_wrapper.data().h
  preview_img.css
    width: Math.round(w) + 'px'
    height: Math.round(h) + 'px'
  true

@init_mini_color = ->
  $('.mini_colors_input').minicolors
    inline: true
    change: (hex) ->
      set_rgb hexToRgb(hex)

set_rgb = (rgb) ->
  console.log rgb
  $('.filter_r').attr('slope', rgb.r*5/255)
  $('.filter_g').attr('slope', rgb.g*5/255)
  $('.filter_b').attr('slope', rgb.b*5/255)
  $('#r_component').attr('value', rgb.r*5/255)
  $('#g_component').attr('value', rgb.g*5/255)
  $('#b_component').attr('value', rgb.b*5/255)

hexToRgb = (hex) ->
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  r: parseInt(result[1], 16)
  g: parseInt(result[2], 16)
  b: parseInt(result[3], 16)
