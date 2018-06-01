# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_token :profile_token

  has_many :ideas, dependent: :destroy

  scope :needs_reminding, lambda {
    joins(:ideas)
      .where(reminders_enabled: true)
      .where.not("ideas.created_at > ?", 6.hours.ago)
      .where.not("reminded_at > ?", 3.hours.ago)
      .distinct
  }

  before_create :set_reminded_at

  def to_param
    profile_token
  end

  def last_idea_at
    ideas.newest.created_at
  end

  def toggle_reminders
    update reminders_enabled: !reminders_enabled?
  end

  def touch_reminded_at
    update reminded_at: Time.zone.now
  end

  private

  def set_reminded_at
    self.reminded_at = Time.zone.now
  end
end
