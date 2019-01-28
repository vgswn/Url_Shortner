class CreateDomainPrefixes < ActiveRecord::Migration[5.2]
  def change
    create_table :domain_prefixes do |t|
      t.string :domain
      t.string :prefix
    end
  end
end
