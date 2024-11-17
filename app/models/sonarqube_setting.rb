# frozen_string_literal: true

class SonarqubeSetting < RedmineSonarqube::Utils::ModelBase
  include Redmine::Ciphering

  belongs_to :project

  validates :url, presence: true
  validates :token, presence: true

  def token
    read_ciphered_attribute(:token)
  end

  def token=(arg)
    write_ciphered_attribute(:token, arg)
  end

  def monitoring_projects
    v = read_attribute(:monitoring_projects)
    YAML.safe_load(v) if v
  end

  def monitoring_projects=(v)
    write_attribute(:monitoring_projects, v.to_yaml.to_s)
  end

  def projects
    return if url.blank?

    @projects = client.projects if @project.blank?

    @projects
  end

  def version
    return if url.blank?

    @version = client.version if @version.blank?

    @version
  end

  def client
    return @client if @clinet.present?

    link_url_normalize = "#{link_url.chomp('/')}/" if link_url.present?

    @client = RedmineSonarqube::SonarqubeClient.new(
      "#{url.chomp('/')}/",
      token,
      skip_ssl_verify,
      link_url_normalize)

    @client
  end
end
