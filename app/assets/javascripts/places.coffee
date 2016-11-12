# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@init_ajax_place_show = ->
  $(".ajax-place_show").on 'ajax:success', (e, data) ->
    myModal = new jBox('Modal', content: data )
    myModal.open()
    $('.tipsy_show_s').tipsy({gravity: 's'})


