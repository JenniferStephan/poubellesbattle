class MessageMailerPreview < ActionMailer::Preview
  def interest_don
    message = Message.last

    MessageMailer.with(message: message).interest_don
  end

  def message_to_members
    message = Message.last

    MessageMailer.with(message: message).message_to_members
  end

  def message_to_agglo
    message = Message.last

    MessageMailer.with(message: message).message_to_agglo
  end

  def message_to_referent
    message = Message.last

    MessageMailer.with(message: message).message_to_referent
  end
end
