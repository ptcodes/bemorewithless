class CommentObserver < ActiveRecord::Observer
  include ActionView::Helpers::TextHelper

  def after_create(comment)
    if comment.gift_comment?
      users = comment.affected_users.each do |user|
        UserMailer.new_gift_comment(comment, user).deliver
      end
    end

    if comment.meeting_comment?
      comment.affected_users(false, true).each do |user|
        UserMailer.new_meeting_comment(comment, user).deliver
      end
    end

    if comment.thank_comment?
      comment.affected_users(false, true).each do |user|
        UserMailer.new_thank_comment(comment, user).deliver
      end
    end
  end

end
