# frozen_string_literal: true

require 'net/http'
require 'json'

module RedmineSonarqube
  class SonarqubeClient
    def initialize(url, token, skip_ssl_verify, link_url)
      @url = url
      @token = token
      @skip_ssl_verify = skip_ssl_verify
      @link_url = link_url
    end

    attr_reader :url, :link_url

    def project_metrics(key)
      metrics = [
        'bugs',
        'vulnerabilities',
        'security_hotspots_reviewed',
        'code_smells',
        'coverage',
        'duplicated_lines_density',
        'ncloc',
        'reliability_rating', # bugs
        'security_rating', # vulnerabilities
        'security_review_rating', # security_hotspots_reviewed
        'sqale_rating', # code_smells
      ]

      q_key = URI.encode_www_form_component(key)
      q_metrics = metrics.join(',')
      request = Net::HTTP::Get.new(abs_path('api/measures/component') + "?component=#{q_key}&metricKeys=#{q_metrics}")
      response = send(request)
      JSON.parse(response.body)
    end

    def project_status(key)
      q_key = URI.encode_www_form_component(key)
      request = Net::HTTP::Get.new(abs_path('api/qualitygates/project_status') + "?projectKey=#{q_key}")
      response = send(request)
      json = JSON.parse(response.body)
      json['projectStatus']['status']
    end

    def projects
      request = Net::HTTP::Get.new(abs_path('api/components/search_projects'))
      response = send(request)
      json = JSON.parse(response.body)
      json['components'].map do |project|
        SonarqubeProject.new(self, project)
      end
    end

    def version
      request = Net::HTTP::Get.new(abs_path('api/system/status'))
      response = send(request)
      json = JSON.parse(response.body)
      json['version']
    end

    private

    def abs_path(rel_path)
      base_uri = URI.parse(@url).path.chomp('/')

      if rel_path.start_with?('/')
        rel_path = rel_path.slice(1..-1)
      end

      "#{base_uri}/#{rel_path.chomp('/')}"
    end

    def send(request)
      uri = URI.parse(@url)

      request.basic_auth(@token, '')

      conn = Net::HTTP.new(uri.host, uri.port)
      conn.use_ssl = uri.scheme == 'https'
      if @skip_ssl_verify
        conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
      else
        conn.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end

      response = conn.start do |http|
        http.request(request)
      end

      response.value # raise if not 2xx

      response
    end
  end
end
