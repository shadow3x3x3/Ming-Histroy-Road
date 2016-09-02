require 'csv'

module OutputUtil
  def self.output_start_codes_csv(path, dataset)
    CSV.open(path, "wb") do |csv|
      dataset.each { |data| csv << data }
    end
  end

  def self.output_setting_csv(path, dataset)
    CSV.open(path, "wb") do |csv|
      csv << dataset
    end
  end
end
