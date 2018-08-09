# frozen_string_literal: true

class Idea < ApplicationRecord
  after_create :send_welcome_email

  include ImageUploader::Attachment.new(:image)

  belongs_to :user

  scope :newest, -> { order(created_at: :desc).first }

  private

  def send_welcome_email
    UserMailer.welcome_email.deliver_now
  end
end
