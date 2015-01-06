JasonHall::Application.routes.draw do

  resources :partners
  devise_for :admins

  root 'home#index'

  get "/blog", to: 'blog#index'
  get "/resources", to: 'resources#index'
  get "/home", to: 'home#index'
  get "/blog/new"
  get "/blog/comments"
  get "/category", to: 'partners#category'
  get '/contact', to: 'contact#index'

  post '/new_program', to: 'resources#new_program'
  post '/edit_program', to: 'resources#edit_program'
  post '/new_process', to: 'resources#new_process'
  post '/edit_process', to: 'resources#edit_process'
  post '/resources/swap', to: 'resources#swap'
  post '/new_question', to: 'resources#new_question'
  post '/edit_question', to: 'resources#edit_question'
  post '/resources/swap_question', to: 'resources#swap_question'
  post '/blog/approve'
  post '/blog/new_comment'
  post '/blog/new_post'
  post '/blog/edit'
  post '/blog/approve_comment'
  post '/blog/delete_comment'
  post '/blog/delete_post'
  post '/new_partner', to: 'partners#new_partner'
  post '/edit_partner', to: 'partners#edit_partner'
  post '/send_feedback', to: 'contact#send_feedback'

  patch '/blog/edit_post/:id', to: 'blog#edit_post'

  delete '/delete_program', to: 'resources#delete_program'
  delete '/delete_process', to: 'resources#delete_process'
  delete '/delete_question', to: 'resources#delete_question'
end
