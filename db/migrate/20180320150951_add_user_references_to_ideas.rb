# frozen_string_literal: true

class AddUserReferencesToIdeas < ActiveRecord::Migration[5.1]
  def change
    add_reference :ideas, :user, foreign_key: true
  end
end
