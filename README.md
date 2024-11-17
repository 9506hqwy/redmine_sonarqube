# Redmine SonarQube

This plugin provides a SonarQube's project observation.

## Features

- Display SonarQube's project summary.

## Installation

1. Download plugin in Redmine plugin directory.
   ```sh
   git clone https://github.com/9506hqwy/redmine_sonarqube.git
   ```
2. Install dependency libraries in Redmine directory.
   ```sh
   bundle install --without development test
   ```
3. Install plugin in Redmine directory.
   ```sh
   bundle exec rake redmine:plugins:migrate NAME=redmine_sonarqube RAILS_ENV=production
   ```
4. Start Redmine

## Configuration

1. Enable plugin module.

   Check [SonarQube] in project setting.

2. Set in [SonarQube] tab in project setting.

   - [URL]

     Input SonarQube server URL.

   - [Skip SSL certificate verification]

     If the server cant not verify the server certification, check on.

   - [Link URL]

     Input SonarQube server URL for browser.
     Specify if different accessible URL from Redmine and browsable URL.
     If omitted, use `URL`.

   - [Token]

     Input token.
     Checked on the trailing checkbox if updating.

3. Save.

4. Select SonarQube's project for observing from Redmine.

5. Save.

## Notes

- Need to use `database_cipher_key` in *configuration.yml* for encrypting token.

- If chagnge `database_cipher_key`, see bellow process.

  1. Decrypt ciphered token.
     ```sh
     bundle exec rails redmine_sonarqube:db:decrypt RAILS_ENV=production
     ```

  2. Change value of `database_cipher_key`.

  3. Encrypt plain token.
     ```sh
     bundle exec rails redmine_sonarqube:db:encrypt RAILS_ENV=production
     ```

- If SonarQube is 10.0 or later, token type is `User Token`.

## Tested Environment

* Redmine (Docker Image)
  * 3.4
  * 4.0
  * 4.1
  * 4.2
  * 5.0
  * 5.1
  * 6.0
* Database
  * SQLite
  * MySQL 5.7 or 8.0
  * PostgreSQL 12
* SonarQube
  * 8.9.3
  * 10.3.0
