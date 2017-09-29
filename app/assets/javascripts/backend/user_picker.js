$.fn.userAutocomplete = function () {
    'use strict';

    function formatUser(user) {
        return Select2.util.escapeMarkup(user.email);
    }

    this.select2({
        minimumInputLength: 1,
        multiple: true,
        initSelection: function (element, callback) {
            $.get(user_search, {
                ids: element.val()
            }, function (data) {
                callback(data.users);
            });
        },
        ajax: {
            url: user_search,
            datatype: 'json',
            data: function (term) {
                return {
                    q: term,
                    token: api_key
                };
            },
            results: function (data) {
                return {
                    results: data.users
                };
            }
        },
        formatResult: formatUser,
        formatSelection: formatUser
    });
};

$(document).ready(function () {
    $('.user_picker').userAutocomplete();
});
