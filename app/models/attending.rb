class Attending < ApplicationRecord
  belongs_to :attendee, class_name: 'User'
  belongs_to :attended_event, class_name: 'Event'

  validates_presence_of :attendee_id, :attended_event_id
  
  scope :confirmed, ->(event_id) { where(attended_event_id: event_id) }

  def self.ransackable_attributes(auth_object = nil)
    ["attended_event_id", "attendee_id", "created_at", "id", "updated_at"]
  end

end