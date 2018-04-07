# Manage Hash records and updates the values
class HashHandler
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

  # Initializing hash key and values
  def initialize(hash)
    @hash = hash
  end

  # parse the records
  def parse
    new_hash = {}
    @hash.map do |e|
      key = e[0]
      array_value = e[1]
      new_hash[key] = format_results(key, array_value)
    end
    new_hash
  end

  # Apply changes to the results
  def format_results(key, array_value)
    case 
    when LAST_VALUE_WINS.include?(key)
      array_value.map { |e| e.nil? ? nil : e }.to_readable_value
    when LAST_REAL_VALUE_WINS.include?(key)
      last_value_handler(array_value)
    when INT_VALUES.include?(key)
      array_value.map { |e| e.nil? ? nil : e.to_s }.to_readable_value
    when FLOAT_VALUES.include?(key)
      float_value_handler(array_value)
    when NUMBER_OF_COMMISSIONS.include?(key)
      array_value.map { |e| e.nil? ? nil : e.to_german_s }.to_readable_value
    when COMMISION_VALUES.include?(key)
      commision_value_handler(array_value)
    end
  end

  # inputs csv row object and returns hash
  def self.combine_hashes(list_of_rows)
    result = {}
    list_of_rows.each do |row|
      next if row.nil?
      row.to_hash.map { |i, v| result[i] = [v].compact }
    end
    result
  end

  private

  # Apply last value checks
  def last_value_handler(values)
    values.reject { |v| (v.nil? || v.zero? || v == '0' || v == '') }
          .to_readable_value
  end

  # Apply changes for float values
  def float_value_handler(values)
    values.map { |e| e.nil? ? nil : e.from_german_to_f.to_german_s }
          .to_readable_value
  end

  # Apply changes for commision values
  def commision_value_handler(values)
    values.map do |e|
      if e.nil?
        nil
      else
        (
          @cancellation_factor * @saleamount_factor * e.from_german_to_f
        ).to_german_s
      end
    end.to_readable_value
  end
end
