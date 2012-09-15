WishYourGift::Application.routes.draw do
  get "mypages/index"
  get "mypages/other_info"
  get "mypages/register_wishlist_id"
  match 'mypage', :to => 'mypages#index', :as => "mypage"

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  root :to => 'top#index'
end
