class Batch::SendMail
  def self.send_mail
    @users = User.all
    @users.each do |user|
    DailyMailer.send_when_daily(user).deliver
    end
    p "メールを送信しました。"
  end
end