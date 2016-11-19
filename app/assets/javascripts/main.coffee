$ ->
  init_categories_menu() if $('.categories_menu').length
  init_place_image_load() if $('.place_image_input_hidden').length
  init_avatar_image_load() if $('.js-avatar_upload').length
  init_tipsy_show()
  init_categories_top()
  init_show_hide_search() if $('a.show_hide_search').length
  init_close_message() if $('a.i_write').length
  init_show_message() if $('a.i_wanna_write').length
  init_image_crop() if $('.js-image_crop').length
  init_place_color_edit() if $('.place .color_edit').length
  init_number_the_ajax_place_show() if('.ajax-place_show').length
  init_ajax_place_show() if $('.ajax-place_show').length
  init_modal_resolve_size() if $('.projects .project.complete').length
  init_mini_color() if $('.mini_colors_input')
  true
