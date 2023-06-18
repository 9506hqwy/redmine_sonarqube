# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  resources :projects do
    get '/sonarqube/projects', to: 'sonarqube_project#index', format: false
    put '/sonarqube_setting', to: 'sonarqube_setting#update', format: false
  end
end
