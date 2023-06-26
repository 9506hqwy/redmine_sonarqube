# frozen_string_literal: true

module RedmineSonarqube
  class SonarqubeProject
    def initialize(client, project)
      @client = client
      @project = project
      @link_url = client.link_url.presence || client.url
    end

    def key
      @project['key']
    end

    def name
      @project['name']
    end

    def id
      Utils.project_key(key) if key.present?
    end
  end
end
