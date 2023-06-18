# frozen_string_literal: true

class CreateSonarqubeSettings < RedmineSonarqube::Utils::Migration
  def change
    create_table :sonarqube_settings do |t|
      t.belongs_to :project, null: false, foreign_key: true
      t.string :url
      t.string :link_url
      t.boolean :skip_ssl_verify
      t.string :token
      t.string :monitoring_projects
    end
  end
end
