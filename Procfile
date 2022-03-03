release: DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:migrate db:seed
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
