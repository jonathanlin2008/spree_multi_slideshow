//= require store/spree_core
// page init
var document_ready = false;
var currend_pic_index = 0;
var cycle_init = false;
$(document).ready(function(){
    if(!document_ready){
        $("#slideshow_paper").children().each(function(){
            $(this).hover(function(){
                    currend_pic_index = parseInt($(this).attr('alt'));
                    $(this).attr('class','thumbnail_current');
                    $(this).siblings().attr('class','thumbnail_other');
                    $('#gallery_slide_cycle').cycle('stop');
                    $("#gallery_slide_cycle").cycle({
                        startingSlide:currend_pic_index
                    });
                    $("#gallery_slide_cycle").cycle('pause');
                },
                function(){
                    cycle_init = true;
                    $("#gallery_slide_cycle").cycle({
                        before: slide_trans_callback,
                        startingSlide:get_index(currend_pic_index)
                    });
                    $("#gallery_slide_cycle").cycle('resume');

                }
            );

        });
        slideer_init();
        document_ready = true;
    }
});
function slide_trans_callback(currSlideElement, nextSlideElement, options, forwardFlag){
    if(!cycle_init) {
        var nchild = get_index(options.nextSlide +1);
        $('#slideshow_paper>:nth-child('+nchild+')').attr('class','thumbnail_current');
        $('#slideshow_paper>:nth-child('+nchild+')').siblings().attr('class','thumbnail_other');
    }
    cycle_init = false;
}
function slideer_init(){
    cycle_init = true;
    $('#gallery_slide_cycle').cycle({
        before: slide_trans_callback
    });
    nchild = 1;
    $('#slideshow_paper>:nth-child('+nchild+')').attr('class','thumbnail_current');
    $('#slideshow_paper>:nth-child('+nchild+')').siblings().attr('class','thumbnail_other');
}
function get_index(ind){
    var len = $("#gallery_slide_cycle").children().length;
    ind = ind>len?len:ind;
    ind = ind<1?len:ind;
    return ind;
}
function imagePager(index,slide) {
    return '<a href="#"><img src="' + slide.src + '" width="110" height="66" /></a>';

}