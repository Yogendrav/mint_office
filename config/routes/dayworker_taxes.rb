Mintoffice::Application.routes.draw do
  resources :dayworker_taxes do
    member do
      get 'payment_request'
    end
  end
end