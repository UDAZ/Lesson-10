# README

# Lesson-10 1日毎にメール定期配信

bundler: not executable: bin/rails
が出たときはbundle exec rake app:update:bin

rails環境変数はhttps://qiita.com/alokrawat050/items/c68ec9578c12fe5a93a3参照

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