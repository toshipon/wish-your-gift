WishYourGift::Application.routes.draw do
  get "gift/show"
  get "wishlist/new"

  get "mypages/index"
  get "mypages/other_info"
  get "mypages/register_wishlist_id"
  get "mypages/share"
  match 'mypage', :to => 'mypages#index', :as => "mypage"

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'gift/:id', :to => 'gift#show'

  root :to => 'top#index'

  resources :wishlist
end
