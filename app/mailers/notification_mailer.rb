class NotificationMailer < ApplicationMailer

  def send_contact_notification(contact)
    @contact = contact
    mail(to: 'info@lienesbeauty.com', subject: "Contact request from: #{@contact.email}", from: 'info@bequent.com')
  end

end
