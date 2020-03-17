npm run build
bundle exec rackup -s agoo -D
bundle exec sidekiq -r ./app.rb