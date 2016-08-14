@init_slider = ->
  $('.js-slider').each (index, item) ->
    $(item).slider({
      step: $(item).data('step'),
      min: $(item).data('min'),
      max: $(item).data('max'),
      value: $(item).data('value')
    })
    $('#to_default_button').on 'click', ->
      $(item).slider('refresh')
