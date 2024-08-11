class Invite < ApplicationRecord

 
  belongs_to :event
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

  validates_presence_of :event_id, :inviter_id, :invitee_id

  scope :received, ->(event_id, user_id) { where(event_id: event_id, invitee_id: user_id) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "event_id", "id", "invitee_id", "inviter_id", "updated_at"]
  end

end