class AddIndexToDomain < ActiveRecord::Migration[5.2]
  def change
  	add_index :domain_prefixes ,:domain
  end
end
