class ChangePartnerAddressColumns < ActiveRecord::Migration
  def change
    remove_column :partners, :address, :string
    add_column :partners, :street_address, :string
    add_column :partners, :city, :string
    add_column :partners, :state, :string
    add_column :partners, :zip, :string
  end
end
