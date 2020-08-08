Rails.application.routes.draw do
  root 'people#index'

 	resources :people, only: [:index] do
 		collection {post :import}
 	end

 	resources :buildings, only: [:index] do
 		collection {post :import}
 	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
