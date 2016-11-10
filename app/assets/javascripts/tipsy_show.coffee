@init_tipsy_show = ->
  $('.tipsy_show').tipsy()
  $('.user_logo').tipsy({gravity: 'e'})
  $('.info_project .statistics').tipsy({gravity: 'e'})
  $('.project .title .glyphicon-ok, .tipsy_show_s').tipsy({gravity: 's'})
