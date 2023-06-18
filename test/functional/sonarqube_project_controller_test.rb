# frozen_string_literal: true

require 'webmock'
require File.expand_path('../../test_helper', __FILE__)

class SonarqubeProjectControllerTest < Redmine::ControllerTest
  include Redmine::I18n
  include WebMock::API

  fixtures :email_addresses,
           :member_roles,
           :members,
           :projects,
           :roles,
           :users,
           :sonarqube_settings

  def setup
    @request.session[:user_id] = 2

    @project = Project.find(5)
    @project.enable_module!(:sonarqube)

    role = Role.find(1)
    role.add_permission!(:view_sonarqube)

    @metrics = [
      'bugs',
      'vulnerabilities',
      'security_hotspots_reviewed',
      'code_smells',
      'coverage',
      'duplicated_lines_density',
      'ncloc',
      'reliability_rating',
      'security_rating',
      'security_review_rating',
      'sqale_rating',
    ]
  end

  def test_index
    WebMock.enable!

    @project.sonarqube_setting.monitoring_projects = ['projectA']
    @project.sonarqube_setting.save!

    query = "projectKey=projectA"
    stub_request(:get, "https://127.0.0.1:9000/api/qualitygates/project_status?#{query}").
      to_return(body: '{"projectStatus": {"status": "OK"}}')
    query = "component=projectA&metricKeys=#{@metrics.join(',')}"
    stub_request(:get, "https://127.0.0.1:9000/api/measures/component?#{query}").
      to_return(body: '{"component": {"name": "projectA", "measures": []}}')

    get :index, params: {
      project_id: @project.id
    }

    assert_response :success
  ensure
    WebMock.disable!
  end

  def test_index_x2
    WebMock.enable!

    @project.sonarqube_setting.monitoring_projects = ['projectA', 'projectB']
    @project.sonarqube_setting.save!

    query = "projectKey=projectA"
    stub_request(:get, "https://127.0.0.1:9000/api/qualitygates/project_status?#{query}").
      to_return(body: '{"projectStatus": {"status": "OK"}}')
    query = "component=projectA&metricKeys=#{@metrics.join(',')}"
    stub_request(:get, "https://127.0.0.1:9000/api/measures/component?#{query}").
      to_return(body: '{"component": {"name": "projectA", "measures": []}}')
    query = "projectKey=projectB"
    stub_request(:get, "https://127.0.0.1:9000/api/qualitygates/project_status?#{query}").
      to_return(body: '{"projectStatus": {"status": "OK"}}')
    query = "component=projectB&metricKeys=#{@metrics.join(',')}"
    stub_request(:get, "https://127.0.0.1:9000/api/measures/component?#{query}").
      to_return(body: '{"component": {"name": "projectB", "measures": []}}')

    get :index, params: {
      project_id: @project.id
    }

    assert_response :success
  ensure
    WebMock.disable!
  end

  def test_index_not_found
    WebMock.enable!

    @project.sonarqube_setting.monitoring_projects = ['projectA']
    @project.sonarqube_setting.save!

    query = "projectKey=projectA"
    stub_request(:get, "https://127.0.0.1:9000/api/qualitygates/project_status?#{query}").
      to_return(status: 404)

    get :index, params: {
      project_id: @project.id
    }

    assert_response :success

    @project.reload
    assert @project.sonarqube_setting.monitoring_projects.empty?
  ensure
    WebMock.disable!
  end
end
