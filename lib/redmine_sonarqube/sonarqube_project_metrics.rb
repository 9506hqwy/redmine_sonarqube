# frozen_string_literal: true

module RedmineSonarqube
  class SonarqubeProjectMetrics
    def initialize(client, status, metrics)
      @client = client
      @status = status
      @metrics = metrics['component']
      @link_url = client.link_url.presence || client.url
    end

    attr_reader :status

    def key
      @metrics['key']
    end

    def name
      @metrics['name']
    end

    def url
      dashboard = @link_url + 'dashboard'
      dashboard.to_s + "?id=#{key}"
    end

    def bugs
      measure('bugs')
    end

    def bugs_rating
      rating(measure('reliability_rating'))
    end

    def code_smells
      measure('code_smells')
    end

    def code_smells_rating
      rating(measure('sqale_rating'))
    end

    def coverage
      measure('coverage')
    end

    def duplicated_lines_density
      measure('duplicated_lines_density')
    end

    def ncloc
      measure('ncloc')
    end

    def security_hotspots_reviewed
      measure('security_hotspots_reviewed')
    end

    def security_hotspots_reviewed_rating
      rating(measure('security_review_rating'))
    end

    def vulnerabilities
      measure('vulnerabilities')
    end

    def vulnerabilities_rating
      rating(measure('security_rating'))
    end

    private

    def measure(key)
      metric = @metrics['measures'].find {|m| m['metric'] == key}
      metric['value'] if metric.present?
    end

    def rating(value)
      return if value.nil?

      val = value.to_i
      if val < 2
        'A'
      elsif val < 3
        'B'
      elsif val < 4
        'C'
      elsif val < 5
        'D'
      else
        'E'
      end
    end
  end
end
