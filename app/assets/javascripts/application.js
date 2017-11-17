// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require cable
//= require slick.min
//= require jquery.cookie
//= require ion.rangeSlider.min
//= require rating
//= require jquery.elevatezoom.min
//= require query-object
//= require social-share-button
//= require lightgallery.min

$(document).on('turbolinks:load', function () {
    $(function () {
        var quickview_modal = $('#quickview-modal');
        $('.star-rating').rateit();
        $(document).on('click', '.quickview', function (e) {
            $.ajax({
                url: $(this).attr('data-action'),
                type: 'get',
                dataType: 'script',
                beforeSend: function () {
                    quickview_modal.find('.modal-body').html("<i class='fa fa-spinner' aria-hidden='true'></i>");
                },
                error: function () {
                    quickview_modal.find('.modal-body').html('Error');
                }
            })
        });

        $(document).on('click', '#notice-close', function () {
            $('#notification').hide();
            return false;
        });
        $("a[href='#nof']").click(function (e) {
            e.preventDefault();
            return false
        });
    });
});

function popupMessage(message, klass) {
    notificationTop = "+" + ($(document).scrollTop() + 60);
    $('#notification').removeClass().addClass('alert ' + klass);
    $('#flash-msg-text').html(message);
    $('#notification').show().animate({
        top: notificationTop
    }, 200);

    setTimeout(function () {
        $('#notification').hide().animate({
            top: "-60"
        }, 500);
    }, 15000);
}