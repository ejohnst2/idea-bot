# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_token :profile_token

  has_many :ideas, dependent: :destroy

  def to_param
    profile_token
  end

  def last_idea_at
    ideas.newest.created_at
  end

  private

end
