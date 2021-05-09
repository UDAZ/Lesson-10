# Lesson-10 1日毎にメール定期配信

### ①メールアドレスとアプリパスワードの環境変数の設定
#### ①ターミナルで.bash_profileを編集
```
vim ~/.bash_profile
```
#### ②.bash_profileを編集
```
export GMAIL='メールアドレス'
export GPASS='パスワード'
```
escで編集モード終了 :wqコマンドで保存して終了
#### ③環境変数の適用
```
source ~/.bash_profile
```
#### ④railsコンソールで環境変数の確認
ターミナル
```
rails c
```
rails コンソールで環境変数確認
```
ENV['GMAIL']
ENV['GPASS']
```
rails コンソールの終了
```
exit
```
※railsコンソールが動作しない場合
```
bundle exec spring stop
```
### ②devlopment.rbにメール設定を追記
config/environments/development.rb
```
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => 'localhost:3000'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => 'smtp.gmail.com',
    :port => 587,
    :domain => 'gmail.com',
    :user_name => ENV['GMAIL'],
    :password => ENV['GPASS'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
```
### ③ActionMailerでDailyMailerを作成
```
rails generate mailer DailyMailer
```
### ④application_mailerとdaily_mailerの編集
app/mailers/application_mailer.rb
```
class ApplicationMailer < ActionMailer::Base
  default from: "管理人 <from@example.com>"
  layout 'mailer'
end
```
app/mailer/daily_mailer.rb
```
class DailyMailer < ApplicationMailer
    def send_when_daily(user)
        @user = user
        mail(to: user.email, subject: '【bookers】毎日配信テスト')
    end
end
```
### ⑤send_when_dailyのviewを作成
send_when_daily.html.erb
```
<h2><%= @user.name %> 様</h2>

<p>メール配信のテストです。</p>
```
send_when_daily.text.erb
```
<%= @user.name %> 様

メール配信のテストです。
```
### ⑥バッチ処理の実装
#### ①libフォルダにbatchフォルダを作成、send_mail.rbファイルを作成
lib/batch/send_mail.rb
```
class Batch::SendMail
  def self.send_mail
    @users = User.all
    @users.each do |user|
    DailyMailer.send_when_daily(user).deliver
    end
    p "メールを送信しました。"
  end
end
```
#### ②バッチ処理の読み込み設定
config/application.rb
```
config.paths.add 'lib', eager_load: true
```
### ⑦バッチ処理の試走
```
bundle exec rails runner Batch::SendMail.send_mail
```
### ⑧wheneverのインストール
Gemfile
```
gem 'whenever', require: false
```
ターミナル
```
bundle install
```
```
bundle exec wheneverize
```
### ⑨wheneverの設定
config/schedule.rb
```
require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = Rails.env.to_sym
set :environment, rails_env
set :output, 'log/cron.log'
every 1.day do
  begin
    runner "Batch::SendMail.send_mail"
  rescue => e
    Rails.logger.error("aborted rails runner")
    raise e
  end
end
```
### ⑩wheneverの設定をcrontab用に翻訳
```
bundle exec whenever
```
### ⑪crontabに反映
```
bundle exec whenever --update-crontab
```
### ⑫cronを起動
```
sudo systemctl start crond
```
### ⑬cronを停止
```
sudo systemctl stop crond
```
### ※bundler: not executable: bin/railsが起きた際の対処法
```
bundle exec rake app:update:bin
```