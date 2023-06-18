# frozen_string_literal: true

require 'webmock'
require File.expand_path('../../test_helper', __FILE__)

class SonarqubeSettingTest < ActiveSupport::TestCase
  include WebMock::API

  fixtures :projects,
           :sonarqube_settings

  def test_create
    p = projects(:projects_001)

    s = SonarqubeSetting.new
    s.project = p
    s.url = 'https://127.0.0.1:9000/'
    s.link_url = 'https://sonarqube:9000/'
    s.skip_ssl_verify = true
    s.token = 'token'
    s.monitoring_projects = ['A', 'B']
    s.save!

    s.reload
    assert_equal p.id, s.project_id
    assert_equal 'https://127.0.0.1:9000/', s.url
    assert_equal 'https://sonarqube:9000/', s.link_url
    assert_equal true, s.skip_ssl_verify
    assert_equal 'token', s.token
    assert_equal 2, s.monitoring_projects.length
    assert_includes s.monitoring_projects, 'A'
    assert_includes s.monitoring_projects, 'B'
  end

  def test_update
    p = projects(:projects_005)

    s = p.sonarqube_setting
    s.url = 'http://127.0.0.1:9000/'
    s.link_url = 'http://sonarqube:9000/'
    s.skip_ssl_verify = false
    s.token = 'password'
    s.monitoring_projects = ['A', 'B']
    s.save!

    s.reload
    assert_equal p.id, s.project_id
    assert_equal 'http://127.0.0.1:9000/', s.url
    assert_equal 'http://sonarqube:9000/', s.link_url
    assert_equal false, s.skip_ssl_verify
    assert_equal 'password', s.token
    assert_equal 2, s.monitoring_projects.length
    assert_includes s.monitoring_projects, 'A'
    assert_includes s.monitoring_projects, 'B'
  end

  def test_version_nil
    s = SonarqubeSetting.new

    v = s.version

    assert_nil v
  end

  def test_version_true
    WebMock.enable!

    stub_request(:get, 'https://127.0.0.1:9000/api/system/status').
        to_return(body: '{}')

    s = SonarqubeSetting.new
    s.url = 'https://127.0.0.1:9000/'

    v = s.version

    assert_nil v
  ensure
    WebMock.disable!
  end
end
