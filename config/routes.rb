Rails.application.routes.draw do

   root 'companies#index'

   
   resources :companies do
   	resources :transactions
   	get 'new_cof_transaction', to: 'transactions#new_cof_transaction'
   	post 'new_cof_transaction', to: 'transactions#create'
   	get 'edit_cof_transaction', to: 'transactions#edit_cof_transaction'
   	patch 'edit_cof_transaction', to: 'transactions#update'
   	put 'edit_cof_transaction', to: 'transactions#update'
   end
   

end
