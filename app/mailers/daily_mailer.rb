class DailyMailer < ApplicationMailer
    def send_when_daily(user)
        @user = user
        mail to user.email, subject: '【bookers】毎日配信テスト'
    end
end
