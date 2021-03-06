Smellyleaf::Application.routes.draw do

  


  devise_for :admins
  devise_for :users
  root 'welcome#index'

  get "modals/login", :as => 'login'
  get "modals/registration", :as => 'registration_modal'

  get "pages/tos", :as => 'terms_of_service'
  get "pages/privacy_policy", :as => 'privacy_policy'

  
  #get "solr", :as => 'store/solr'
  #get 'search' => 's#search'

  #unsubscribe action in emails
  #get '/profile/unsubscribe/:signature' => 'profile#unsubscribe', as: 'unsubscribe'

  resources :profile do
    member do
      get "activity"
      get "feed"
      post "follow"
      get 'following'
      # get "followingusers"
      # get "followingstores"
      # get "followingitems"
      post "unfollow"
      get "myreviews"
      get "edit_photo"
      put "update_photo"
    end
  end

  resources :feeds do
    
    resources :feed_posts do
      resources :feed_post_comments
      resources :feed_post_votes
      member do 
        get 'add_flag'
        post 'flag'        
        get 'prompt_delete'
      end
    end
  end
  

  resources :ses

  namespace :admin do
      # Directs /admin/products/* to Admin::ProductsController
      # (app/controllers/admin/products_controller.rb)
      resources :stores
      #resources :flags
      
      get 'flags/index'
      delete 'flags/destroy'
      
    end

  resources :stores do
    resources :cancellations
    # custom edit modal panel routes.  Needed to add custom controller endpoints and these routes match those.
    member do
      get 'error_authorization'
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
      post 'unfollow'
      get 'edit_promo'
      put 'update_promo'
      get "edit_photo"
      put "update_photo"
      get 'archived_items'
      get 'subscription_plans'
      get 'unauthorized_subscription_plans'
      post 'subscribe_store'
      get 'change_credit_card'
      post 'update_credit_card'
      


    end
    
    resources :store_items do 
      member do
        post 'follow'
        post 'unfollow'
        get 'delete_prompt'        
        get 'restore_modal'
        post 'undestroy'
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
