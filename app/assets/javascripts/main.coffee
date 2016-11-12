$ ->
  init_categories_menu() if $('.categories_menu').length
  init_place_image_load() if $('.place_image_input_hidden').length
  init_avatar_image_load() if $('.js-avatar_upload').length
  init_tipsy_show()
  init_image_crop() if $('.js-image_crop').length
  init_place_color_edit() if $('.place .color_edit').length
  init_slider() if $('.js-slider').length
  init_ajax_place_show() if $('.ajax-place_show').length
  init_modal_resolve_size() if $('.projects .project.complete').length
  true
