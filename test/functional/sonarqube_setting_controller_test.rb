# frozen_string_literal: true

require 'webmock'
require File.expand_path('../../test_helper', __FILE__)

class SonarqubeSettingControllerTest < Redmine::ControllerTest
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

    role = Role.find(1)
    role.add_permission!(:edit_sonarqube_setting)
  end

  def test_update_create
    WebMock.enable!

    project = Project.find(1)
    project.enable_module!(:sonarqube)

    stub_request(:get, 'https://127.0.0.1:9000/api/system/status').
        to_return(body: '{"version": "1"}')

    put :update, params: {
      project_id: project.id,
      enable: true,
      url: 'https://127.0.0.1:9000/',
      link_url: 'https://sonarqube:9000/',
      skip_ssl_verify: false,
      password: 'token',
      monitoring_projects: ['A']
    }

    assert_redirected_to "/projects/#{project.identifier}/settings/sonarqube"
    assert_not_nil flash[:notice]
    assert_nil flash[:error]

    project.reload
    assert_equal 'https://127.0.0.1:9000/', project.sonarqube_setting.url
    assert_equal 'https://sonarqube:9000/', project.sonarqube_setting.link_url
    assert_equal false, project.sonarqube_setting.skip_ssl_verify
    assert_equal 'token', project.sonarqube_setting.token
    assert_equal 1, project.sonarqube_setting.monitoring_projects.length
    assert_includes project.sonarqube_setting.monitoring_projects, 'A'
  ensure
    WebMock.disable!
  end

  def test_update_deny_permission
    project = Project.find(2)
    project.enable_module!(:sonarqube)

    put :update, params: {
      project_id: project.id,
      enable: true,
      url: 'https://127.0.0.1:9000/',
      link_url: 'https://sonarqube:9000/',
      skip_ssl_verify: false,
      password: 'token',
      monitoring_projects: ['A']
    }

    assert_response 403
  end

  def test_update_update
    WebMock.enable!

    project = Project.find(5)
    project.enable_module!(:sonarqube)

    stub_request(:get, 'http://127.0.0.1:9000/api/system/status').
        to_return(body: '{"version": "1"}')

    put :update, params: {
      project_id: project.id,
      enable: true,
      url: 'http://127.0.0.1:9000/',
      link_url: 'http://sonarqube:9000/',
      skip_ssl_verify: true,
      password: 'password',
      monitoring_projects: ['A']
    }

    assert_redirected_to "/projects/#{project.identifier}/settings/sonarqube"
    assert_not_nil flash[:notice]
    assert_nil flash[:error]

    project.reload
    assert_equal 'http://127.0.0.1:9000/', project.sonarqube_setting.url
    assert_equal 'http://sonarqube:9000/', project.sonarqube_setting.link_url
    assert_equal true, project.sonarqube_setting.skip_ssl_verify
    assert_equal 'password', project.sonarqube_setting.token
    assert_equal 1, project.sonarqube_setting.monitoring_projects.length
    assert_includes project.sonarqube_setting.monitoring_projects, 'A'
  ensure
    WebMock.disable!
  end

  def test_update_destroy
    project = Project.find(5)
    project.enable_module!(:sonarqube)

    put :update, params: {
      project_id: project.id,
      enable: false
    }

    assert_redirected_to "/projects/#{project.identifier}/settings/sonarqube"
    assert_not_nil flash[:notice]
    assert_nil flash[:error]

    project.reload
    assert_nil project.sonarqube_setting
  end
end
