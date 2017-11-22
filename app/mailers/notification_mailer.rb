class NotificationMailer < ApplicationMailer

  def send_contact_notification(contact)
    @contact = contact
    mail(to: 'info@lienesbeauty.com', subject: "Contact request from: #{@contact.email}", from: 'sales@lienesbeauty.com')
  end

  def send_subscription_notification(email)
    @email = email
    mail(to: email, subject: "Lienesbeauty subscription gift", from: 'sales@lienesbeauty.com')
  end

end
