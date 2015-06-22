Rails.application.routes.draw do
  devise_for :users
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  
  resources :sessions, :as => 'karate_sessions', :path => 'karate_sessions'

  resources :awards

  resources :styles

  resources :tests

  resources :colors

  resources :ranks

  resources :people do
    collection do
      get 'search'
    end
    member do
      get 'attendance'
    end
  end

  get 'reports' => 'reports#index'
  get 'reports/promotions_due' => 'reports#promotions_due'
  get 'reports/tests_due' => 'reports#tests_due'
  get 'reports/recent_promotions' => 'reports#recent_promotions'
  get 'reports/attendance' => 'reports#attendance'
  get 'reports/active_students' => 'reports#active_students'
  get 'reports/promotions_by_date_form' => 'reports#promotions_by_date_form'
  get 'reports/promotions_by_date' => 'reports#promotions_by_date'
  
  get 'attendances' => 'attendances#index'
  get 'attendances/form' => 'attendances#form'
  post 'attendances/add' => 'attendances#add'
  post 'attendances/add_by_session' => 'attendances#add_by_session'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'attendances#index'

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
