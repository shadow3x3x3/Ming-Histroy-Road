require 'csv'

module OutputUtil
  def self.output_2_csv(dataset)
    CSV.open("output/ming_dataset.csv", "wb") do |csv|
      dataset.each { |data| csv << data }
    end
  end
end
