# frozen_string_literal: true

module RedmineSonarqube
  module ProjectPatch
    def self.prepended(base)
      base.class_eval do
        has_one :sonarqube_setting, dependent: :destroy
      end
    end
  end
end

Project.prepend RedmineSonarqube::ProjectPatch
