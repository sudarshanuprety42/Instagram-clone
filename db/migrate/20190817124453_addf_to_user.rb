class AddfToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :followers, :integer, array: true, default: []
    add_column :users, :followings, :integer, array: true, default: []
  end
end
