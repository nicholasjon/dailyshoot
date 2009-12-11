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

$(document).ready(function() {
 
   function showAdminActions() {
     var menu = $(this);
     menu.children(".admin-actions").slideDown();
   }
  
   function hideAdminActions() { 
     var menu = $(this);
     menu.children(".admin-actions").slideUp();
   }
 
   $(".hover-menu").hoverIntent({
     sensitivity: 1,           // number = sensitivity threshold (must be 1 or higher)
     interval: 300,             // number = milliseconds for onMouseOver polling interval
     over: showAdminActions,   // function = onMouseOver callback (required)
     timeout: 300,             // number = milliseconds delay before onMouseOut
     out: hideAdminActions     // function = onMouseOut callback (required)
   });
  
});