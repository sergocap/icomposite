@init_image_upload = ->
  preview = $('.js-image_upload')

  $('.image_load_button').on 'change', (e) ->
    file = $(this).prop('files')[0]

    reader = new FileReader()
    reader.onload = (e) ->
      image = e.target.result
      preview.attr('src', image)

    reader.readAsDataURL(file)
