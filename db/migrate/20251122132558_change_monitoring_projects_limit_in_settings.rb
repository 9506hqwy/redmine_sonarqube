# frozen_string_literal: true

class ChangeMonitoringProjectsLimitInSettings < RedmineSonarqube::Utils::Migration
  def up
    change_column(:sonarqube_settings, :monitoring_projects, :text)
  end

  def down
    change_column(:sonarqube_settings, :monitoring_projects, :string)
  end
end
