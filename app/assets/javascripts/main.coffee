$ ->
  init_place_image_load() if $('.js-place_image_upload').length
  init_image_crop() if $('.js-image_crop').length
  init_place_color_edit() if $('.place .color_edit').length
  true
