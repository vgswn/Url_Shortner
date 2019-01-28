class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :date
      t.integer :no_of_urls
    end
  end
end
