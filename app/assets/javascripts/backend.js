// require modernizr
//= require jquery
//= require bootstrap-sprockets
//= require handlebars
//= require jquery.cookie
//= require jquery.jstree/jquery.jstree
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require jquery-ui/sortable
//= require jquery-ui/autocomplete
//= require select2
//= require underscore-min.js
//= require velocity

//= require syftet.js.coffee.erb
//= require backend/spree-select2
//= require backend/address_states
//= require backend/adjustments
//= require backend/admin
//= require backend/calculator
//= require backend/checkouts/edit
//= require backend/gateway
//= require backend/general_settings
// require backend/handlebar_extensions
//= require backend/line_items
//= require backend/line_items_on_order_edit
//= require backend/nested-attribute
//= require backend/option_type_autocomplete
//= require backend/option_value_picker
//= require backend/orders/edit
//= require backend/orders/edit_form
//= require backend/payments/edit
//= require backend/payments/new
//= require backend/product_picker
//= require backend/progress
//= require backend/promotions
//= require backend/returns/expedited_exchanges_warning
//= require backend/returns/return_item_selection
// require backend/shipments
//= require backend/states
//= require backend/stock_management
//= require backend/stock_movement
//= require backend/stock_transfer
//= require backend/taxon_autocomplete
//= require backend/taxon_tree_menu
//= require backend/taxonomy
//= require backend/taxons
//= require backend/user_picker
//= require backend/variant_autocomplete
//= require backend/variant_management
//= require backend/zone
//= require backend/jscolor.min

//Spree.routes.clear_cache = Spree.adminPathFor('general_settings/clear_cache')
//Spree.routes.checkouts_api = Spree.pathFor('api/v1/checkouts')
//Spree.routes.classifications_api = Spree.pathFor('api/v1/classifications')
//Spree.routes.option_type_search = Spree.pathFor('api/v1/option_types')
//Spree.routes.option_value_search = Spree.pathFor('api/v1/option_values')
//Spree.routes.orders_api = Spree.pathFor('api/v1/orders')
//Spree.routes.products_api = Spree.pathFor('api/v1/products')
product_search = ''; //adminPathFor('search/products');
//Spree.routes.shipments_api = Spree.pathFor('api/v1/shipments')
//Spree.routes.checkouts_api = Spree.pathFor('api/v1/checkouts')
//Spree.routes.stock_locations_api = Spree.pathFor('api/v1/stock_locations')
//Spree.routes.taxon_products_api = Spree.pathFor('api/v1/taxons/products')
taxons_search = '/admin/taxons/search'; //Syftet.pathFor('api/v1/taxons');
user_search = ''; //Spree.adminPathFor('search/users')
api_key = 'dfsdfdsfd';
//Spree.routes.variants_api = Spree.pathFor('api/v1/variants')
//
//Spree.routes.edit_product = function(product_id) {
//  return Spree.adminPathFor('products/' + product_id + '/edit')
//}
//
//Spree.routes.payments_api = function(order_id) {
//  return Spree.pathFor('api/v1/orders/' + order_id + '/payments')
//}
//
//Spree.routes.stock_items_api = function(stock_location_id) {
//  return Spree.pathFor('api/v1/stock_locations/' + stock_location_id + '/stock_items')
//}
