class Event < ApplicationRecord

  has_many :invites, dependent: :destroy
  has_many :attendings, foreign_key: :attended_event_id, dependent: :destroy
  has_many :attendees, through: :attendings, dependent: :destroy
  belongs_to :creator, class_name: "User"
  
  validates :name, :location, :date, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates_presence_of :creator_id

  # scope allows common queries to be defined herein and method names set
  
  scope :past_events, -> { where('date < ? AND active = ?', Time.zone.now, true) }
  scope :future_events, -> { where('date > ? AND active = ?', DateTime.now, true) }

  def self.ransackable_associations(auth_object = nil)
    ["attendees", "attendings", "creator", "invites"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "creator_id", "date", "description", "id", "location", "name", "private", "updated_at", "active"]
  end

end