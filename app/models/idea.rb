# frozen_string_literal: true

class Idea < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  belongs_to :user

  scope :newest, -> { order(created_at: :desc).first }
end
