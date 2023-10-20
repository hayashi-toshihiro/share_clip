# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + '/environment')

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

set :job_template, "/bin/zsh -l -c ':job'"
job_type :rake, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

#定期実行したい処理を記入
every 1.week, roles: %i(app) do
  rake '-s sitemap:refresh'
end

every 1.week do
  runner 'ViewHistory.where("created_at < ?", 30.days.ago.beginning_of_day).delete_all'
end