LeadMailer::Application.routes.draw do
  resources :lead_mails
  root :to => "lead_mails#index"

  match '/hooks' => "hooks#dispatcher", :via => "post"
end