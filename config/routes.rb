Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  namespace :admin do
    resources :orders do
      resources :payments do
        get :get_parcels, on: :collection
      end
    end
  end
end
