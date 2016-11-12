# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@init_modal_resolve_size = ->
  $('.projects .project.complete .resolve_size').on 'click', ->
    myModal = new jBox('Modal',
      ajax: {
        url: '/modal_resolve_size',
        data: 'id=' + $(this).data().project_id,
        reload: true
      }
    )
    myModal.open()
