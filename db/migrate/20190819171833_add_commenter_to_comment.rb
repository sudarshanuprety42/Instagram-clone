class AddCommenterToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :commenter, :integer
  end
end
