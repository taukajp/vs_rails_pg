#!/usr/bin/env bash

set -e

bundle exec rails new . -f -B -d postgresql --skip-action-mailer --skip-action-mailbox --skip-action-text --skip-action-cable --skip-aciton-storage
# cat <<EOF >> Gemfile
# gem "rails-i18n"
# group :development, :test do
#   gem "standard"
#   gem "solargraph"
#   gem "debug"
#   gem "htmlbeautifier"
# end
# EOF
# bundle install
bundle add rails-i18n
bundle add standard solargraph debug htmlbeautifier --group "development, test"
bundle lock --add-platform ruby
bundle lock --add-platform x86_64-linux

sed -i '/# config.time_zone/a \    config.time_zone = ENV["TZ"]\n    # config.active_record.default_timezone = :local\n    # config.i18n.default_locale = :ja' config/application.rb
sed -i '/pool:/a \  username: vscode\n  password:\n  host: db' config/database.yml
# bin/rails webpacker:install

cat <<EOF >> .standard.yml
ruby_version: $RUBY_MAJOR
ignore:
  - 'vendor/**/*'
EOF

cat <<EOF >> .gitignore
/vendor/bundle
.env
.DS_Store
EOF

bin/rails db:create
bin/rails db:migrate
