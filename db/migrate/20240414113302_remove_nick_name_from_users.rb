class RemoveNickNameFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :nick_name, :string
  end
end
