@init_image_edit = ->

  $('.image_button').on 'click', ->
    $('.image_load_button').click()

  canvas = $('.canvas')
  context = canvas[0].getContext('2d')
  preview = $('.js-image_upload')

  $('.set_place_size_button').on 'click', ->
    draw_net(context)

  $('.image_load_button').on 'change', (e) ->
    file = $(this).prop('files')[0]
    if file.type.split('/')[0] == 'image'
      reader = new FileReader()
      reader.onload = (e) ->
        background = new Image()
        background.src = e.target.result
        preview.attr('src', e.target.result)
        $('.image_edit_wrapper')[0].style.display = 'block'
        canvas.attr('width', preview.width())
        canvas.attr('height', preview.height())
        canvas[0].style.backgroundImage = 'url(' + e.target.result + ')'
        draw_net(context)
      reader.readAsDataURL(file)
    else
      $('.image_edit_wrapper')[0].style.display = 'none'
      alert 'Выберите картинку'

draw_net = (context) ->
  place_width =   parseInt($('#project_size_place_x')[0].value)
  place_height =  parseInt($('#project_size_place_y')[0].value)
  image_width = context.canvas.width
  image_height = context.canvas.height
  context.clearRect(0, 0, image_width, image_height);
  for i in [0..image_height] by place_height
    set_line(context, 0, i, image_width, i)
  for i in [0..image_width] by place_width
    set_line(context, i, 0, i, image_height)

set_line = (context, x1, y1, x2, y2) ->
  context.beginPath()
  context.moveTo(x1, y1)
  context.lineTo(x2, y2)
  context.stroke()
