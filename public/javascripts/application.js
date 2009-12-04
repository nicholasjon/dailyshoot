$(function() {
    var countdown = {
        init: function() {
            countdown.remaining = countdown.max - $(countdown.obj).val().length;
            if (countdown.remaining > countdown.max) {
                $(countdown.obj).val($(countdown.obj).val().substring(0,countdown.max));
            }
            $(".remaining").html(countdown.remaining + " characters remaining");
        },
        max: null,
        remaining: null,
        obj: null
    };
    $(".countdown").each(function() {
        $(this).focus(function() {
            var c = $(this).attr("class");
            countdown.max = parseInt(c.match(/limit_[0-9]{1,}_/)[0].match(/[0-9]{1,}/)[0]);
            countdown.obj = this;
            iCount = setInterval(countdown.init,1000);
        }).blur(function() {
            countdown.init();
            clearInterval(iCount);
        });
    });
});