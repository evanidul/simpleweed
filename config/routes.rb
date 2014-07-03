Smellyleaf::Application.routes.draw do

  devise_for :admins
  devise_for :users
  root 'welcome#index'

  get "modals/login", :as => 'login'
  get "modals/registration", :as => 'registration_modal'
  # resources :stores

  #get "solr", :as => 'store/solr'
  #get 'search' => 's#search'

  resources :profile do
    member do
      get "activity"
      get "feed"
      post "follow"
      get "followingusers"
      get "followingstores"
      get "followingitems"
      post "unfollow"
    end
  end

  

  resources :ses

  namespace :admin do
      # Directs /admin/products/* to Admin::ProductsController
      # (app/controllers/admin/products_controller.rb)
      resources :stores
    end

  resources :stores do
    # custom edit modal panel routes.  Needed to add custom controller endpoints and these routes match those.
    member do
      get 'edit_description'
      put 'update_description'
      get 'edit_firsttimepatientdeals'
      put 'update_firsttimepatientdeals'
      get 'edit_dailyspecials'
      put 'update_dailyspecials'
      get 'edit_contact'
      put 'update_contact'
      get 'edit_features'
      put 'update_features'
      get 'edit_announcement'
      put 'update_announcement'
      get 'edit_deliveryarea'
      put 'update_deliveryarea'
      get 'edit_hours'
      put 'update_hours'
      get 'store_preview'
      get 'show_claim'
      put 'update_claim'
      post 'follow'

    end
    resources :store_items do 
      member do
        post 'follow'
      end
      resources :store_item_reviews do
        resources :store_item_review_comments
        resources :store_item_review_votes
      end
    end
    resources :store_reviews do
      resources :store_review_votes
      resources :store_review_comments
    end
  end    


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
