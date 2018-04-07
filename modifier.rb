require 'csv'
require 'date'
Dir['./lib/*.rb', './lib/overrides/*.rb'].each { |f| require f }

# Modifier class for parsing performance record and generate sorted and audited results
class Modifier
  KEYWORD_UNIQUE_ID = 'Keyword Unique ID'.freeze

  def initialize(saleamount_factor, cancellation_factor)
    @saleamount_factor = saleamount_factor
    @cancellation_factor = cancellation_factor
  end

  def modify(output, input)
    input = CsvManager.sort(input, 'Clicks')
    input_enumerator = CsvManager.lazy_read(input)

    combiner = Combiner.new do |value|
      value[KEYWORD_UNIQUE_ID]
    end.combine(input_enumerator)
    merger = HashHandler.record_merger(combiner)
    CsvManager.merge_records(merger, output)
  end
end

modified = input = FileManager.latest('project_2012-07-27_2012-10-10_performancedata')
modification_factor = 1
cancellaction_factor = 0.4
modifier = Modifier.new(modification_factor, cancellaction_factor)
modifier.modify(modified, input)

puts 'DONE modifying'
