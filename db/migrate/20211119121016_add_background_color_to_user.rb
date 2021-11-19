class AddBackgroundColorToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :background_header_color, :string, default: '#005a55'
  end
end
