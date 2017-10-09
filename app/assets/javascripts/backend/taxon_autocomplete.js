'use strict';

var set_taxon_select = function (selector) {
    function formatTaxon(taxon) {
        return Select2.util.escapeMarkup(taxon.pretty_name);
    }

    if ($(selector).length > 0) {
        $(selector).select2({
            placeholder: translations.taxon_placeholder,
            multiple: true,
            initSelection: function (element, callback) {
                var url = Syftet.url(Syftet.routes.taxons_search, {
                    ids: element.val(),
                    without_children: true,
                    token: api_key
                });
                return $.getJSON(url, null, function (data) {
                    return callback(data['taxons']);
                });
            },
            ajax: {
                url: Syftet.routes.taxons_search,
                datatype: 'json',
                data: function (term, page) {
                    return {
                        per_page: 50,
                        page: page,
                        without_children: true,
                        q: {
                            name_cont: term
                        },
                        token: api_key
                    };
                },
                results: function (data, page) {
                    var more = page < data.pages;
                    return {
                        results: data['taxons'],
                        more: more
                    };
                }
            },
            formatResult: formatTaxon,
            formatSelection: formatTaxon
        });
    }
};

$(document).ready(function () {
    set_taxon_select('#product_taxon_ids')
});
