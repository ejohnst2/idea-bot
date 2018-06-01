# frozen_string_literal: true

class CreateIdeas < ActiveRecord::Migration[5.1]
  def change
    create_table :ideas do |t|
      t.string :name
      t.text :image_data

      t.timestamps
    end
  end
end
