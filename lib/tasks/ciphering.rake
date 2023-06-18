# frozen_string_literal: true

namespace :redmine_sonarqube do
  namespace :db do
    desc 'Encrypts SonarQube secret in the database.'
    task encrypt: :environment do
      unless SonarqubeSetting.encrypt_all(:token)
        raise "Some objects could not be saved after encryption, update was rolled back."
      end
    end

    desc 'Decrypts SonarQube secret in the database.'
    task decrypt: :environment do
      unless SonarqubeSetting.decrypt_all(:token)
        raise "Some objects could not be saved after decryption, update was rolled back."
      end
    end
  end
end
