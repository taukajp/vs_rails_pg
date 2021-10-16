#!/usr/bin/env bash

set -e

test -s Gemfile.lock && exit 0

mv .gitignore .gitignorebk
sudo chmod -R a+w vendor
bundle exec rails new . -f -B -d postgresql -c tailwind --skip-action-mailer --skip-action-mailbox --skip-action-text --skip-ci --skip-docker --skip-kamal
# cat <<EOF >> Gemfile
# gem "rails-i18n"
# group :development do
#   gem "yard", require: false
#   gem "htmlbeautifier"
# end
# EOF
# bundle install
bundle add rails-i18n
bundle add yard htmlbeautifier --require false --group "development"
bundle lock --add-platform ruby
bundle lock --add-platform x86_64-linux

TMP=config/application.rb
sed -e '/# config.time_zone/a \    config.time_zone = ENV.fetch("TZ")\n    # config.active_record.default_timezone = :local\n    # config.i18n.default_locale = :ja' \
  ${TMP} > ${TMP}.tmp && \
mv -f ${TMP}.tmp ${TMP}

TMP=config/database.yml
sed -e '/pool:/a \  username: <%= ENV.fetch("DB_NAME") { ''root'' } %>\n  password: <%= ENV.fetch("DB_PASSWORD") { ''password'' } %>\n  host: <%= ENV.fetch("DB_HOST") { ''localhost'' } %>' \
  ${TMP} > ${TMP}.tmp && \
mv -f ${TMP}.tmp ${TMP}

cat .gitignorebk >> .gitignore && rm .gitignorebk

bin/rails db:create
bin/rails db:migrate
bin/rails importmap:install
bin/rails tailwindcss:install
bin/rails turbo:install
bin/rails stimulus:install

exit 0
