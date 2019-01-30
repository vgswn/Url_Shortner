class Report < ApplicationRecord
  validates :date ,uniqueness: true
  validates :no_of_urls , presence: true
  
  def self.get_report
    report = Report.all.order(:date)
  end
end
  