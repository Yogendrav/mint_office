Mintoffice::Application.routes.draw do
  resources :commutes do
  	collection do
      post 'excel', as: :excel
    end
  end

end