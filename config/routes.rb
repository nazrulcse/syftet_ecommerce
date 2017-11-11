Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :blogs, only: [:show, :index] do
    resources :comments, only: [:create]
  end
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'users'
      get 'home', to: 'home#index'
      resources :products, only: [:index, :show] do
        get 'filters', on: :collection
      end
      resources :wishlists, only: [:index, :create]
      resources :orders, only: [:index, :show]
      resources :shipments, only: [:create, :update] do
        member do
          put :ship
        end
      end
    end
  end

  devise_for :users, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       passwords: 'users/passwords'
                   }
  as :user do
    get 'login', to: 'users/sessions#new', as: :user_login
    delete 'logout', to: 'devise/sessions#destroy', as: :user_logout
    get 'registration', to: 'users/registrations#new', as: :account_registration
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  resources :feedbacks, only: [:new, :create, :show]

  get '/c/*id', to: 'taxons#show', as: :categories
  get '/promo/:q/products', to: 'products#index', as: :promotion_products

  get '/frequently-asked-question', to: 'public#faq', as: :faq
  get '/coupon-code', to: 'public#coupon', as: :coupon
  get '/return-policy', to: 'public#return_policy', as: :return_policy
  match '/dedicated-customer-support', to: 'public#contact_us', via: [:get, :post], as: :contact_us
  get '/free-shipping-worldwide', to: 'public#international', as: :international
  get '/safe_shopping_guarantee', to: 'public#safe_shopping_guarantee', as: :safe_shopping_guarantee
  get '/secure_shopping', to: 'public#secure_shopping', as: :secure_shopping
  get '/about_us', to: 'public#about_us', as: :about_us
  get '/privacy_policy', to: 'public#privacy_policy', as: :privacy_policy
  get '/term_condition', to: 'public#term_condition', as: :term_condition
  get '/my_account', to: 'users#my_account'
  get '/cart', to: 'public#cart'
  get '/p_checkout', to: 'public#checkout'
  post '/email_subscription', to: 'public#subscribe'
  get '/users', to: redirect('/registration')

  get '/payment', to: 'checkout#edit', as: :checkout_payment
  get '/delivery', to: 'checkout#edit', as: :checkout_delivery
  patch '/checkout/update/:state', to: 'checkout#update', as: :update_checkout
  get '/checkout/:state', to: 'checkout#edit', as: :checkout_state
  get '/checkout', to: 'checkout#edit', as: :cart_checkout

  resources :contacts, only: [:new, :create]

  resources :carts

  resources :wishlists, only: [:index, :destroy]
  resources :products do
    post :review
    resources :wishlists, only: [:create]
    get :quickview
    get :compare
    get :remove_compare
  end

  resources :orders, except: [:index, :new, :create, :destroy] do
    post :populate, on: :collection
    get :reset, on: :collection
    get :shipped_track
  end

  # Payment Gateway

  post '/paypal', :to => "paypal#express", :as => :paypal_express
  get '/paypal/confirm', :to => "paypal#confirm", :as => :confirm_paypal
  get '/paypal/cancel', :to => "paypal#cancel", :as => :cancel_paypal
  get '/paypal/notify', :to => "paypal#notify", :as => :notify_paypal

  # END PAYMENT #

  namespace :admin do
    get '/search/users', to: 'search#users', as: :search_users
    get '/search/products', to: 'search#products', as: :search_products

    resources :promotions do
      resources :promotion_rules
      resources :promotion_actions
    end

    resources :blogs do
      resources :comments, only: [:destroy, :edit, :update]
    end

    resources :promotion_categories, except: [:show]

    resources :zones

    resources :countries do
      resources :states
    end
    resources :states
    resources :tax_categories

    resources :products do
      resources :reviews, only: [:index, :edit, :destroy, :update]
      resources :product_properties do
        collection do
          post :update_positions
        end
      end
      resources :images do
        collection do
          post :update_positions
        end
      end
      member do
        post :clone
        get :stock
        match 'related', via: [:get, :put]
        get :remove_related
        get :search_related
        get :review
      end
      resources :variants do
        collection do
          post :update_positions
        end
      end
      resources :variants_including_master, only: [:update]
    end

    get '/variants/search', to: "variants#search", as: :search_variants

    resources :option_types do
      collection do
        post :update_positions
        post :update_values_positions
      end
    end

    delete '/option_values/:id', to: "option_values#destroy", as: :option_value

    resources :properties do
      collection do
        get :filtered
      end
    end

    delete '/product_properties/:id', to: "product_properties#destroy", as: :product_property

    resources :prototypes do
      member do
        get :select
      end

      collection do
        get :available
      end
    end

    resources :orders, except: [:show] do
      member do
        get :cart
        post :resend
        get :open_adjustments
        get :close_adjustments
        put :approve
        put :cancel
        put :resume
      end

      resources :state_changes, only: [:index]

      resource :customer, controller: "orders/customer_details"
      resources :customer_returns, only: [:index, :new, :edit, :create, :update] do
        member do
          put :refund
        end
      end

      resources :adjustments
      resources :return_authorizations do
        member do
          put :fire
        end
      end
      resources :payments do
        member do
          put :fire
        end

        resources :log_entries
        resources :refunds, only: [:new, :create, :edit, :update]
      end

      resources :reimbursements, only: [:index, :create, :show, :edit, :update] do
        member do
          post :perform
        end
      end
    end

    get '/return_authorizations', to: "return_index#return_authorizations", as: :return_authorizations
    get '/customer_returns', to: "return_index#customer_returns", as: :customer_returns

    resource :general_settings do
      collection do
        post :clear_cache
      end
    end

    resources :return_items, only: [:update]

    resources :taxonomies do
      collection do
        post :update_positions
      end
      resources :taxons
    end

    resources :taxons, only: [:index, :show] do
      collection do
        get :search
      end
    end

    resources :reports, only: [:index] do
      collection do
        get :sales_total
        post :sales_total
      end
    end

    resources :reimbursement_types, only: [:index]
    resources :refund_reasons, except: :show
    resources :return_authorization_reasons, except: :show

    resources :shipping_methods
    resources :shipping_categories
    resources :stock_transfers, only: [:index, :show, :new, :create]
    resources :stock_locations do
      resources :stock_movements, except: [:edit, :update, :destroy]
      collection do
        post :transfer_stock
      end
    end

    resources :stock_items, only: [:create, :update, :destroy]
    resources :store_credit_categories
    resources :tax_rates
    resources :trackers
    resources :payment_methods do
      collection do
        post :update_positions
      end
    end
    resources :roles

    resources :users do
      member do
        get :addresses
        put :addresses
        put :clear_api_key
        put :generate_api_key
        get :items
        get :orders
      end
      resources :store_credits
    end
  end
  get '/admin', to: 'admin/root#index', as: :admin
end
