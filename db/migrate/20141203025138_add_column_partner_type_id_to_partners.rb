class AddColumnPartnerTypeIdToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :partner_type_id, :integer
  end
end
