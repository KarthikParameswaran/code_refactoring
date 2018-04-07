require 'csv'
require 'date'
Dir['./lib/*.rb', './lib/overrides/*.rb'].each { |f| require f }

# MultipleFileModifier class for parsing performance record and generate sorted and audited results
# Inputting multiple files to see the result
class MultipleFileModifier
  KEYWORD_UNIQUE_ID = 'Keyword Unique ID'.freeze

  def initialize(saleamount_factor, cancellation_factor)
    @saleamount_factor = saleamount_factor
    @cancellation_factor = cancellation_factor
  end

  def modify(output, input_files)
    sorted_input = CsvManager.sort_multiple(output, input_files, 'Clicks')
    input_enumerator = CsvManager.lazy_read(sorted_input)
    combiner = Combiner.new do |value|
      value[KEYWORD_UNIQUE_ID]
    end.combine(input_enumerator)
    merger = HashHandler.record_merger(combiner)
    CsvManager.merge_records(merger, output)
  end
end

input_files = FileManager.fetch_files('project_2012-07-27_2012-10-10_performancedata')
output_files = './workspace/project_2012-07-27_2012-10-10_performancedata.txt'
modification_factor = 1
cancellaction_factor = 0.4

modifier = MultipleFileModifier.new(modification_factor, cancellaction_factor)
modifier.modify(output_files, input_files)

puts 'DONE modifying'
