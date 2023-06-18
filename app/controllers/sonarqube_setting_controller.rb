# frozen_string_literal: true

class SonarqubeSettingController < ApplicationController
  before_action :find_project_by_project_id, :authorize

  def update
    setting = @project.sonarqube_setting || SonarqubeSetting.new

    begin
      if params[:enable].present? && params[:enable] != 'false'
        setting.project = @project
        setting.url = params[:url]
        setting.link_url = params[:link_url]
        setting.skip_ssl_verify = params[:skip_ssl_verify].present? && params[:skip_ssl_verify] != 'false'
        setting.token = params[:password] if params[:password].present?
        setting.monitoring_projects = (params[:monitoring_projects] || []).reject {|m| m.blank? }

        setting.version # test connectivity
        setting.save!

        flash[:notice] = l(:notice_successful_update)
      elsif setting.url.present?
        @project.sonarqube_setting.destroy!

        flash[:notice] = l(:notice_successful_update)
      end
    rescue => e
      Rails.logger.error(e)
      flash[:error] = e.message
    end

    redirect_to settings_project_path(@project, tab: :sonarqube)
  end
end
