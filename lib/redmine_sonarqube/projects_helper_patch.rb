# frozen_string_literal: true

module RedmineSonarqube
  module ProjectsHelperPatch
    def project_settings_tabs
      action = {
        name: 'sonarqube',
        controller: :sonarqube_setting,
        action: :update,
        partial: 'sonarqube_setting/show',
        label: :sonarqube_setting,
      }

      tabs = super
      tabs << action if User.current.allowed_to?(action, @project)
      tabs
    end
  end
end

Rails.application.config.after_initialize do
  ProjectsController.send(:helper, RedmineSonarqube::ProjectsHelperPatch)
end
