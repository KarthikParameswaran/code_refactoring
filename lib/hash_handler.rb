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
      return array_value.join(",")
    when LAST_REAL_VALUE_WINS.include?(key)
      return array_value.join(",")
    when INT_VALUES.include?(key)
      return array_value.join(",")
    when FLOAT_VALUES.include?(key)
      return array_value.join(",")
    when NUMBER_OF_COMMISSIONS.include?(key)
      return array_value.join(",")
    when COMMISION_VALUES.include?(key)
      return array_value.join(",")
    end
  end
end
