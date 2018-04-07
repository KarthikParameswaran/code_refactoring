Dir['./lib/*.rb', './lib/overrides/*.rb'].each {| f| require f }
require 'csv'
require 'date'

# Modifier class for parsing performance record and generate sorted and audited results
class Modifier
  KEYWORD_UNIQUE_ID = 'Keyword Unique ID'.freeze
  LINES_PER_FILE    = 120000

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
    merger = record_merger(combiner)
    CsvManager.merge_records(merger, output)
  end

  private

  def record_merger(combiner)
    Enumerator.new do |yielder|
      flag = true
      while flag
        begin
          list_of_rows = combiner.next
          merged = HashHandler.combine_hashes(list_of_rows)
          yielder.yield(HashHandler.new(merged).parse)
        rescue StopIteration
          flag = false
          break
        end
      end
    end
  end
end

modified = input = FileManager.latest('project_2012-07-27_2012-10-10_performancedata')
modification_factor = 1
cancellaction_factor = 0.4
modifier = Modifier.new(modification_factor, cancellaction_factor)
modifier.modify(modified, input)

puts 'DONE modifying'
