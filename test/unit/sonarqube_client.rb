# frozen_string_literal: true

require 'webmock'
require File.expand_path('../../test_helper', __FILE__)

class SonarqubeClientTest < ActiveSupport::TestCase
  include WebMock::API

  fixtures :projects,
           :sonarqube_settings

  def setup
    @setting = sonarqube_settings(:sonarqube_settings_001)
    @client = @setting.client
  end

  def test_project
    WebMock.enable!

    stub_request(:get, "https://127.0.0.1:9000/api/projects/search").
        to_return(body: '{"components": [{"key": "A", "name": "a"}]}')

    projects = @client.projects

    assert_equal 'A', projects[0].key
    assert_equal 'a', projects[0].name
  ensure
    WebMock.disable!
  end

  def test_version
    WebMock.enable!

    stub_request(:get, "https://127.0.0.1:9000/api/system/status").
        to_return(body: '{"version": "1"}')

    version = @client.version

    assert_equal '1', version
  ensure
    WebMock.disable!
  end
end
