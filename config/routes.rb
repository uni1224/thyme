Rails.application.routes.draw do
# 顧客用
# URL /users/sign_in ...
devise_for :users,skip: [:passwords], controllers: {
  registrations: "user/registrations",
  sessions: 'user/sessions'
}


scope module: :user do
  root to: 'homes#top'
  get 'users/about' => 'homes#about', as: 'about'
  get 'users/mypage' => 'users#show', as: 'mypage'
  get 'users/information/edit' => 'users#edit', as: 'edit_information'
  patch 'users/information' => 'users#update', as: 'update_information'
  get 'users/quit' => 'users#quit', as: 'confirm_quit'
  put 'users/information' => 'users#update'
  patch 'users/out' => 'users#out', as: 'out_user'
  resources :reservations
end

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

namespace :admin do
  root to: 'homes#top'
  get 'users/:user_id/resarvations' => 'resarvations#index', as: 'user_resarvations'
  get 'admins/information/edit' => 'admins#edit', as: 'edit_information'
  patch 'admins/information' => 'admins#update', as: 'update_information'
  get 'admins/quit' => 'admins#quit', as: 'confirm_quit'
  put 'admins/information' => 'admins#update'
  patch 'admins/out' => 'admins#out', as: 'out_salon'
  resources :reservations
  resources :users, only: %i[show index edit update]
end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
