@init_image_edit = ->
  $('.image_button').on 'click', ->
    $('.image_load_button').click()

  canvas = $('.canvas')
  context = canvas[0].getContext('2d')
  preview = $('.js-image_upload')
  $('.image_load_button').on 'change', (e) ->
    file = $(this).prop('files')[0]
    reader = new FileReader()
    reader.onload = (e) ->
      background = new Image()
      background.src = e.target.result
      preview.attr('src', e.target.result)
      $('.image_edit_wrapper')[0].style.display = 'block'
      canvas.attr('width', preview.width())
      canvas.attr('height', preview.height())
      context.drawImage(background, 0, 0)
    reader.readAsDataURL(file)
