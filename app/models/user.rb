class User < ApplicationRecord
  has_secure_token :device_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :invites, foreign_key: :inviter_id, dependent: :destroy
  has_many :invites, foreign_key: :invitee_id, dependent: :destroy
  has_many :attendings, foreign_key: :attendee_id, dependent: :destroy
  has_many :attended_events, through: :attendings, dependent: :destroy
  
  has_many :events, foreign_key: :creator_id, class_name: "Event", dependent: :destroy

  def self.ransackable_associations(auth_object = nil)
    ["attended_events", "attendings", "events", "invites"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at", "username", "active"]
  end

  scope :attending_event, ->(event_id) { self.attendings.where(attended_event_id: event_id).exists? }

end
