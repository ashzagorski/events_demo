# frozen_string_literal: true

class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads, primary_key: 'lead_id' do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :state
      t.string :street
      t.string :city
      t.string :zip_code
      t.string :color
      t.uuid :guid
      t.column :created_at, 'timestamp with time zone'
      t.column :updated_at, 'timestamp with time zone'
    end
  end
end
