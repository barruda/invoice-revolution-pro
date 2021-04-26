# build/validate-migrated.sh
  /bin/sleep 15
  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rails s -b 0.0.0.0 -p 3000