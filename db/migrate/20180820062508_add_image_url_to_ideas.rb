class AddImageUrlToIdeas < ActiveRecord::Migration[5.2]
  def change
    add_column :ideas, :image_url, :string
  end
end
