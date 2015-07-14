Rails.application.routes.draw do

   root 'companies#index'

   
   resources :companies do
   	resources :transactions
   	get 'new_cof_transaction', to: 'transactions#new_cof_transaction'
   	post 'new_cof_transaction', to: 'transactions#create_cof_transaction'
   end
   

end
