class DailyMailer < ApplicationMailer
  def confirmation
    mail(:subject => "確認メール", bcc: User.pluck(:email))
  end
end
