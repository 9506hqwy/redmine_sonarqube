# frozen_string_literal: true

class SonarqubeProjectController < ApplicationController
  before_action :find_project_by_project_id, :authorize

  def index
    setting = @project.sonarqube_setting || SonarqubeSetting.new

    projects = []
    not_found = []
    (setting.monitoring_projects || []).each do |proj_key|
      begin
        status = client.project_status(proj_key)
        metrics = client.project_metrics(proj_key)
        projects.push(RedmineSonarqube::SonarqubeProjectMetrics.new(client, status, metrics, setting.link_url))
      rescue Net::HTTPExceptions => e
        if e.response.code == '404'
          not_found.push(proj_key)
        else
          return render_error(message: e.message)
        end
      rescue => e
        return render_error(message: e.message)
      end
    end

    if not_found.any?
      setting.monitoring_projects = setting.monitoring_projects.reject! { |k| not_found.include?(k) }
      setting.save
    end

    @sonarqube_projects = projects.sort_by {|p| p.name}
  end

  private

  def client
    @project.sonarqube_setting.client if @project.sonarqube_setting.present?
  end
end
