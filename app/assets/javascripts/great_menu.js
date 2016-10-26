function init_categories_menu() {

    var $el, leftPos, newWidth;
        $mainNav = $("#menu");

    var $magicLine = $("#magic-line");
    $magicLine.css({
      'background-color': $(".current_page_item a").attr("rel"),
      'width' : $(".current_page_item").width(),
      'height' : $mainNav.height(),
      'left' : $(".current_page_item a").position().left
    });

    $magicLine
        .width($(".current_page_item").width())
        .height($mainNav.height())
        .css("left", $(".current_page_item a").position().left)
        .data("origLeft", $(".current_page_item a").position().left)
        .data("origWidth", $magicLine.width())
        .data("origColor", $(".current_page_item a").attr("rel"));

    $("#menu a").hover(function() {
        $el = $(this);
        leftPos = $el.position().left;
        newWidth = $el.parent().width();
        $magicLine.stop().animate({
            left: leftPos,
            width: newWidth,
            backgroundColor: $el.attr("rel")
        }, 150)
    }, function() {
        $magicLine.stop().animate({
            left: $magicLine.data("origLeft"),
            width: $magicLine.data("origWidth"),
            backgroundColor: $magicLine.data("origColor")
        },150);
    });

    $(".current_page_item a").mouseenter();
}
