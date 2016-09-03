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
  $('#saturate').on 'change', (e) ->
    $('#filter_saturate').attr('values', $(this).val())
  $('#blur').on 'change', (e) ->
    $('#filter_blur')[0].setAttribute('stdDeviation', $(this).val())
  $('#r_component').on 'change', (e) ->
    $('#filter_r').attr('slope', $(this).val())
  $('#g_component').on 'change', (e) ->
    $('#filter_g').attr('slope', $(this).val())
  $('#b_component').on 'change', (e) ->
    $('#filter_b').attr('slope', $(this).val())

  $('#to_default_button').on 'click', ->
    $('#filter_saturate').attr('values', 1)
    $('#filter_blur')[0].setAttribute('stdDeviation', 0)
    $('#filter_r').attr('slope', 1)
    $('#filter_g').attr('slope', 1)
    $('#filter_b').attr('slope', 1)
