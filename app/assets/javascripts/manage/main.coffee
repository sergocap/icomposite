$ ->
  init_image_upload() if $('.js-image_upload').length
  init_image_edit()   if $('.js-image_upload').length
  true
