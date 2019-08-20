class AlterUsers < ActiveRecord::Migration[5.2]
  def change
         add_column :users, :fullname, :string
         add_column :users, :username, :string,:unique=>true
         add_column :users, :bio, :text,:null=>true
         add_column :users, :is_private, :boolean, :default=>'false'
         add_column :users, :gender, :string, :default=>'Prefer not to say'

         change_column_null :users, :fullname, false
         change_column_null :users, :username, false
         change_column_null :users, :gender, false
         change_column_null :users, :is_private, false
  end
end
