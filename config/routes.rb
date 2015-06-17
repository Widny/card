Rails.application.routes.draw do

   root 'transactions#index'

   resources :transactions

end
