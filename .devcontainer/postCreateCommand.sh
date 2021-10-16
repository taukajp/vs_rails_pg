#!/usr/bin/env bash

set -e

test -d app && exit 0

mv .gitignore .gitignorebk
sudo chmod -R a+w vendor
bundle exec rails new . -f -B -d postgresql  -a propshaft -c tailwind --skip-action-mailer --skip-action-mailbox --skip-action-text --skip-action-cable --skip-aciton-storage
# cat <<EOF >> Gemfile
# gem "rails-i18n"
# group :development, :test do
#   gem "debug", require: false
#   gem "rubocop", require: false
#   gem "yard", require: false
#   gem "htmlbeautifier"
# end
# EOF
# bundle install
bundle add rails-i18n
bundle add debug rubocop yard htmlbeautifier --require false --group "development, test"
bundle lock --add-platform ruby
bundle lock --add-platform x86_64-linux

TMP=config/application.rb
sed -e '/# config.time_zone/a \    config.time_zone = ENV.fetch("TZ")\n    # config.active_record.default_timezone = :local\n    # config.i18n.default_locale = :ja' \
  ${TMP} > ${TMP}.tmp && \
mv -f ${TMP}.tmp ${TMP}

TMP=config/database.yml
sed -e '/pool:/a \  username: docker\n  password:\n  host: db' \
  ${TMP} > ${TMP}.tmp && \
mv -f ${TMP}.tmp ${TMP}

cat .gitignorebk >> .gitignore && rm .gitignorebk

bin/rails db:create
bin/rails db:migrate
bin/rails importmap:install
bin/rails turbo:install
bin/rails tailwindcss:install
bin/rails stimulus:install

exit 0
