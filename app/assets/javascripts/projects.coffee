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

@init_close_message = ->
  $('a.i_write').on 'click', ->
    $('.info_icomposite').slideUp()

@init_show_message = ->
  $('a.i_wanna_write').on 'click', ->
    $('.info_icomposite').slideDown()

@init_show_hide_search = ->
  $('a.show_hide_search').on 'click', ->
    $('.search_project_form').slideToggle()
