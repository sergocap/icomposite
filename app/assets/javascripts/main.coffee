$ ->
  init_categories_menu() if $('.categories_menu').length
  init_place_image_load() if $('.js-place_image_upload').length
  init_avatar_image_load() if $('.js-avatar_upload').length
  init_tipsy_show() if $('.tipsy_show').length
  init_image_crop() if $('.js-image_crop').length
  init_place_color_edit() if $('.place .color_edit').length
  init_slider() if $('.js-slider').length
  true
