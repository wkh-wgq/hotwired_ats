class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user

  after_create_commit :update_users

  scope :unread, -> { where(read_at: nil) }

  # serialize :params, JSON

  def update_users
    broadcast_replace_later_to(
      user,
      :notification,
      target: "notifications-contailer",
      partial: "nav/notifications",
      locals: {
        user: user
      }
    )
  end

  def read!
    udpate_column(:read_at, Time.current)
  end

  def to_partial_path
    "notifications/notification"
  end
end
