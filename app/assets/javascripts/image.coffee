@init_image_upload = ->
  $('.image_button').on 'click', ->
    $('.image_load_button').click()

  canvas = $('.canvas')
  preview = $('.js-image_upload')
  $('.image_load_button').on 'change', (e) ->
    file = $(this).prop('files')[0]
    reader = new FileReader()
    reader.onload = (e) ->
      preview.attr('src', e.target.result)
      canvas.attr('width', preview.width())
      canvas.attr('height', preview.height())
    reader.readAsDataURL(file)
