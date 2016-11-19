@init_number_the_ajax_place_show = ->
  $('.ajax-place_show').each (i, e) =>
    $(e).attr('data-id', i)

@init_ajax_place_show = ->
  myModal = null
  $('.ajax-place_show').on 'ajax:success', (e, data) ->
    myModal = new jBox('Modal', onClose: destroy_jBox, content: data )
    myModal.open()
    $('.tipsy_show_s').tipsy({gravity: 's'})

    id = $(this).data('id')
    next_id = get_next_id id
    previous_id = get_previous_id id

    $('.place .show td.link.right').attr('data-target_id', next_id)
    $('.place .show td.link.left').attr('data-target_id', previous_id)

  $(document.body).on 'mouseup', '.place .show td.link', ->
    target_id = $(this).data('target_id')
    target_place = $(".ajax-place_show[data-id='" + target_id + "']")
    $(target_place).addClass('active')
    target_url = $(".ajax-place_show[data-id='" + target_id + "']").attr('href')
    next_id = get_next_id target_id
    previous_id = get_previous_id target_id

    $.ajax target_url,
      success: (data) ->
        myModal.setContent(data)
        $('.place .show td.link.right').attr('data-target_id', next_id)
        $('.place .show td.link.left').attr('data-target_id', previous_id)

  $(document.body).on 'mousedown mouseup', '.place .show td.link', ->
    $(this).toggleClass 'active'

get_next_id = (id) ->
  if id == $('.ajax-place_show').length - 1
    return 0
  else
    return id + 1

get_previous_id = (id) ->
  if id == 0
    return $('.ajax-place_show').length - 1
  else
    return id - 1

destroy_jBox = () ->
  $('.jBox-wrapper.jBox-Modal.jBox-Default').remove()
