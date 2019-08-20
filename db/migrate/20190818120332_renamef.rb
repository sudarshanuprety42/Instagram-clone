class Renamef < ActiveRecord::Migration[5.2]
  def change
    rename_column :followers, :follower_id, :flwr
    rename_column :followings, :following_id, :flwg
  end
end
