class Report < ApplicationRecord
	validates :date ,uniqueness: true

	def self.get_report
		@report = Report.all
	end
end
