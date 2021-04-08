Rails.application.routes.draw do
	namespace :site do
		get "welcome/index"
		get "search", to: "search#questions"
		get "subject/:subject_id/:subject", to: "search#subject", as: "search_subject"
		post "answer", to: "answer#question"
	end
	namespace :users_backoffice do
		get "welcome/index"
		get "profile", to: "profile#edit"
		patch "profile", to: "profile#update"
	end
	devise_for :users

	namespace :admins_backoffice do
		get "welcome/index" # Dashboard welcome
		# get "admins/index"
		# get "admins/edit:id", to: "admins#edit"
		# apenas as rotas padronizadas do scaffold que foram selecionadas
		# resources :admins, only: [:index, :edit, :update, :new, :create] 
		resources :admins # todas as rotas padronizadas do scaffold
		resources :subjects # todas as rotas padronizadas do scaffold
		resources :questions # todas as rotas padronizadas do scaffold
	end
	devise_for :admins, skip: [:registrations]

	get "inicio", to: "site/welcome#index"
	get "backoffice", to: "admins_backoffice/welcome#index"

	root to: "site/welcome#index"
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
