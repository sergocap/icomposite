// DOM Ready
$(function() {

    var $el, leftPos, newWidth;
        $mainNav = $("#menu");

    $mainNav.append("<li id='magic-line'></li>");

    var $magicLine = $("#magic-line");
    $magicLine.css({backgroundColor: $(".current_page_item a").attr("rel")});
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

    /* Kick IE into gear */
    $(".current_page_item a").mouseenter();
    //$.noConflict();


});
