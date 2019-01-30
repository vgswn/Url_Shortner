class Report < ApplicationRecord
  validates :date ,uniqueness: true
  validates :no_of_urls , presence: true
  
  def self.get_report(date)
  	puts date
    report = Report.where(date:date)
  end
end
  