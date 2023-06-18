# frozen_string_literal: true

basedir = File.expand_path('../lib', __FILE__)
libraries =
  [
    'redmine_sonarqube/utils',
    'redmine_sonarqube/projects_helper_patch',
    'redmine_sonarqube/project_patch',
    'redmine_sonarqube/sonarqube_client',
    'redmine_sonarqube/sonarqube_project_metrics',
    'redmine_sonarqube/sonarqube_project',
  ]

libraries.each do |library|
  require_dependency File.expand_path(library, basedir)
end

Redmine::Plugin.register :redmine_sonarqube do
  name 'Redmine SonarQube plugin'
  author '9506hqwy'
  description 'This is a SonarQube plugin for Redmine'
  version '0.1.0'
  url 'https://github.com/9506hqwy/redmine_sonarqube'
  author_url 'https://github.com/9506hqwy'

  project_module :sonarqube do
    permission :view_sonarqube, {
      sonarqube_project: [:index],
    }

    permission :edit_sonarqube_setting, {
      sonarqube_setting: [:update],
    }
  end

  menu :project_menu, :sonarqube, {controller: :sonarqube_project, action: :index}, caption: 'SonarQube', param: :project_id
end
