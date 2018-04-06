require_relative 'lib/combiner'
require_relative 'lib/csv_manager'
require_relative 'lib/file_manager'
require_relative 'lib/hash_handler'
Dir[Dir.pwd + 'lib/overrides/*.rb'].each { |f| require_relative f }
require 'csv'
require 'date'

# Modifier class for parsing performance record and generate sorted and audited results
class Modifier
  KEYWORD_UNIQUE_ID     = 'Keyword Unique ID'.freeze
  NUMBER_OF_COMMISSIONS = ['number of commissions'].freeze
  LAST_REAL_VALUE_WINS  = ['Last Avg CPC', 'Last Avg Pos'].freeze
  FLOAT_VALUES          = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos'].freeze
  LAST_VALUE_WINS       = ['Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword',
                           'Keyword Type', 'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID',
                           'ACCOUNT', 'CAMPAIGN', 'BRAND', 'BRAND+CATEGORY', 'ADGROUP',
                           'KEYWORD'].freeze
  INT_VALUES            = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks',
                           'BRAND - Clicks', 'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks',
                           'KEYWORD - Clicks'].freeze
  COMMISION_VALUES      = ['Commission Value', 'ACCOUNT - Commission Value',
                           'CAMPAIGN - Commission Value', 'BRAND - Commission Value',
                           'BRAND+CATEGORY - Commission Value', 'ADGROUP - Commission Value',
                           'KEYWORD - Commission Value'].freeze

  LINES_PER_FILE = 120000

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
          merged = combine_hashes(list_of_rows)
          yielder.yield(HashHandler.new(merged).parse)
        rescue StopIteration
          flag = false
          break
        end
      end
    end
  end

  def combine_values(hash)
    LAST_VALUE_WINS.each do |key|
      hash[key] = hash[key].last
    end
    LAST_REAL_VALUE_WINS.each do |key|
      hash[key] = hash[key].select {|v| not (v.nil? or v == 0 or v == '0' or v == '')}.last
    end
    INT_VALUES.each do |key|
      hash[key] = hash[key][0]
    end
    FLOAT_VALUES.each do |key|
      hash[key] = hash[key][0].nil? ? nil : hash[key][0].from_german_to_f.to_german_s
    end
    NUMBER_OF_COMMISSIONS.each do |key|
      hash[key] = hash[key][0].nil? ? nil : (@cancellation_factor * hash[key][0].from_german_to_f).to_german_s
    end
    COMMISION_VALUES.each do |key|
      hash[key] = hash[key][0].nil? ? nil : (@cancellation_factor * @saleamount_factor * hash[key][0].from_german_to_f).to_german_s
    end
    hash
  end

  def combine_hashes(list_of_rows)
    result = {}
    list_of_rows.each do |row|
      next if row.nil?
      row.to_hash.map { |i, v| result[i] = [v].compact }
    end
    result
  end
end

modified = input = FileManager.latest('project_2012-07-27_2012-10-10_performancedata')
modification_factor = 1
cancellaction_factor = 0.4
modifier = Modifier.new(modification_factor, cancellaction_factor)
modifier.modify(modified, input)

puts "DONE modifying"
