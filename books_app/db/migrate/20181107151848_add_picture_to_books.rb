# frozen_string_literal: true

class AddPictureToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :picture, :string
  end
end
