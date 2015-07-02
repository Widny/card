Rails.application.routes.draw do

   root 'companies#index'

   
   resources :companies do
   	resources :transactions
   end
   

end
