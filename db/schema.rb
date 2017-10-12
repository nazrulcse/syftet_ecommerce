# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171012124828) do

  create_table "addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "address1"
    t.string "city"
    t.string "zipcode"
    t.string "phone"
    t.string "state"
    t.string "company"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adjustments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "source_id"
    t.string "source_type"
    t.integer "adjustable_id"
    t.string "adjustable_type"
    t.decimal "amount", precision: 10, default: "0"
    t.string "label"
    t.boolean "mandatory"
    t.boolean "eligible"
    t.string "state"
    t.integer "order_id"
    t.boolean "included"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "viewable_id"
    t.string "viewable_type"
    t.integer "attachment_width"
    t.integer "attachment_height"
    t.integer "attachment_file_size"
    t.integer "position"
    t.string "attachment_contant"
    t.string "attachment_file_name"
    t.string "asset_type"
    t.datetime "attachment_updated_at"
    t.string "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_content_type"
  end

  create_table "calculators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "calculator_type"
    t.integer "calculable_id"
    t.string "calculable_type"
    t.text "preferences"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.string "order_number"
    t.string "inquiry_type"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "inventory_units", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "state"
    t.integer "variant_id"
    t.integer "order_id"
    t.integer "shipment_id"
    t.boolean "pending"
    t.integer "line_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.integer "order_id"
    t.integer "quantity"
    t.float "price", limit: 24
    t.float "cost_price", limit: 24
    t.string "currency"
    t.decimal "adjustment_total", precision: 10
    t.decimal "promo_total", precision: 10
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "included_tax_total", precision: 10, default: "0"
    t.decimal "additional_tax_total", precision: 10, default: "0"
    t.decimal "non_taxable_adjustment_total", precision: 10, default: "0"
    t.decimal "taxable_adjustment_total", precision: 10, default: "0"
  end

  create_table "newsletter_subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "option_value_variants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "option_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "position"
    t.string "name"
    t.string "presentation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_promotions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order_id"
    t.integer "promotion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "number"
    t.decimal "item_total", precision: 10
    t.decimal "total", precision: 10
    t.string "state"
    t.decimal "adjustment_total", precision: 10
    t.integer "user_id"
    t.datetime "completed_at"
    t.integer "bill_address_id"
    t.integer "ship_address_id"
    t.decimal "payment_total", precision: 10
    t.string "shipment_state"
    t.string "payment_state"
    t.string "email"
    t.string "currency"
    t.string "last_ip_address"
    t.string "created_by_id"
    t.decimal "shipment_total", precision: 10
    t.decimal "promo_total", precision: 10
    t.string "chanel"
    t.integer "item_count"
    t.integer "approver_id"
    t.datetime "approved_at"
    t.boolean "confirmation_delivered"
    t.boolean "considered_risky"
    t.string "guest_token"
    t.datetime "canceled_at"
    t.integer "canceler_id"
    t.integer "store_id"
    t.integer "state_lock_version"
    t.date "shipment_date"
    t.integer "shipment_progress"
    t.datetime "shipped_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "included_tax_total", precision: 10, default: "0"
    t.decimal "additional_tax_total", precision: 10, default: "0"
    t.text "special_instructions"
  end

  create_table "prices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.float "amount", limit: 24
    t.string "currency"
    t.datetime "deleted_at"
    t.float "agent_price", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_properties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "value"
    t.integer "product_id"
    t.integer "property_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string "slug"
    t.string "meta_title"
    t.string "meta_description"
    t.string "meta_keywords"
    t.integer "tax_category_id"
    t.integer "shipping_category_id"
    t.boolean "promotionable"
    t.integer "taxon_id"
    t.integer "brand_id"
    t.boolean "is_master"
    t.integer "serial_no"
    t.datetime "discontinue_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_featured", default: false
  end

  create_table "products_taxons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "taxon_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promotions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description"
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string "name"
    t.string "promotion_type"
    t.integer "usage_limit"
    t.string "match_policy"
    t.string "code"
    t.boolean "advertise"
    t.string "path"
    t.integer "promotion_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "presentation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "rating"
    t.text "text"
    t.integer "product_id"
    t.integer "user_id"
    t.string "email"
    t.boolean "is_approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tracking"
    t.string "number"
    t.decimal "cost", precision: 10, default: "0"
    t.datetime "shipped_at"
    t.integer "order_id"
    t.integer "address_id"
    t.string "state"
    t.integer "stock_location_id"
    t.decimal "adjustment_total", precision: 10, default: "0"
    t.decimal "additional_tax_total", precision: 10, default: "0"
    t.decimal "promo_total", precision: 10, default: "0"
    t.decimal "included_tax_total", precision: 10, default: "0"
    t.decimal "pre_tax_amount", precision: 10, default: "0"
    t.decimal "taxable_adjustment_total", precision: 10, default: "0"
    t.decimal "non_taxable_adjustment_total", precision: 10, default: "0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_method_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipping_category_id"
    t.integer "shipping_method_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_methods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "display_on"
    t.datetime "deleted_at"
    t.string "admin_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "tracking_url"
  end

  create_table "shipping_rates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipment_id"
    t.integer "shipping_method_id"
    t.boolean "selected"
    t.float "cost", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "state_changes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "previous_state"
    t.integer "stateful_id"
    t.integer "user_id"
    t.string "stateful_type"
    t.string "next_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "stock_location_id"
    t.integer "variant_id"
    t.integer "count_on_hand", default: 0
    t.boolean "backorderable"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.boolean "default"
    t.string "address1"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "country"
    t.string "phone"
    t.boolean "active"
    t.boolean "backorderable_default"
    t.boolean "propagate_all_variants"
    t.string "admin_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_movements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "stock_item_id"
    t.integer "quantity"
    t.string "action"
    t.integer "originator_id"
    t.string "originator_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_transfers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "transfer_type"
    t.string "reference"
    t.integer "source_location_id"
    t.integer "destination_location_id"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "url"
    t.text "meta_description"
    t.string "meta_keywords"
    t.string "seo_title"
    t.string "mail_from_address"
    t.string "default_currency"
    t.string "code"
    t.boolean "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taxonomies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "meta_title"
    t.string "meta_key"
    t.string "meta_description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
  end

  create_table "taxons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "parent_id"
    t.string "name"
    t.string "permalink"
    t.integer "taxonomy_id"
    t.string "description"
    t.string "meta_title"
    t.string "meta_keywords"
    t.string "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lft"
    t.integer "rgt"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "syftet_api_key"
    t.integer "ship_address_id"
    t.integer "bill_address_id"
    t.string "user_type"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "sku"
    t.decimal "weight", precision: 10
    t.decimal "width", precision: 10
    t.decimal "height", precision: 10
    t.decimal "depth", precision: 10
    t.datetime "deleted_at"
    t.boolean "is_master"
    t.integer "product_id"
    t.decimal "cost_price", precision: 10
    t.integer "position"
    t.string "cost_currency"
    t.integer "stock_items_count"
    t.datetime "discontinue_on"
    t.string "color"
    t.string "color_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "track_inventory", default: true
  end

  create_table "wishlists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
