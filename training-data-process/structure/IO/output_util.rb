require 'csv'

module OutputUtil
  def self.output_start_codes_csv(path, dataset)
    CSV.open(path, "wb",
      write_headers: true,
      headers: ["a", "b", "c", "d", "days"]) do |csv|
      dataset.each { |data| csv << data }
    end
  end

  def self.output_setting_csv(path, dataset)
    CSV.open(path, "wb",
      write_headers: true,
      headers: ["a", "b", "c", "d"]) do |csv|
      csv << dataset
    end
  end
end
