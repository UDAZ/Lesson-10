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

$ rails generate mailer DailyMailer
https://qiita.com/annaaida/items/81d8a3f1b7ae3b52dc2b

bundler: not executable: bin/rails
が出たときはbundle exec rake app:update:bin

rails環境変数はlocal_envで記述、application.rbで読み込み
https://qiita.com/alokrawat050/items/c68ec9578c12fe5a93a3参照

まずはbatcherでbundle exec rails runner Batch::〇〇〇〇.〇〇_〇〇を試して、
wheneverでcrontabをアップデート、crondを起動

batcherは
class Batch::SendMail
  def self.send_mail
    @users = User.all
    @users.each do |user|
    DailyMailer.send_when_daily(user).deliver
    end
    p "メールを送信しました。"
  end
end

的な感じで！