
function init_categories_top(){

    var h_hght = 85; // высота шапки
    var h_mrg = 0;    // отступ когда шапка уже не видна
    var elem = $('.categories_menu');
    var top = $(this).scrollTop();

    if(top > h_hght){
        elem.css('top', h_mrg);
    }

    $(window).scroll(function(){
        top = $(this).scrollTop();

        if (top+h_mrg < h_hght) {
            elem.css('top', (h_hght-top));
        } else {
            elem.css('top', h_mrg);
        }
    });

}
