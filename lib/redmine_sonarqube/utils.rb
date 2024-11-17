# frozen_string_literal: true

module RedmineSonarqube
  module Utils
    if ActiveRecord::VERSION::MAJOR >= 5
      Migration = ActiveRecord::Migration[4.2]
    else
      Migration = ActiveRecord::Migration
    end

    if defined?(ApplicationRecord)
      # https://www.redmine.org/issues/38975
      ModelBase = ApplicationRecord
    else
      ModelBase = ActiveRecord::Base
    end

    def self.project_key(key)
      digest = Digest::MD5.new
      digest.update(key)
      "project-#{digest.hexdigest}"
    end
  end
end
