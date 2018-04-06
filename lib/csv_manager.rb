# Manage CSV Operations
class CsvManager
  DEFAULT_CSV_OPTIONS = { col_sep: ', ', headers: :first_row }.freeze
  class << self
    def parse(file)
      CSV.read(file, DEFAULT_CSV_OPTIONS)
    end

    def lazy_read(file)
      Enumerator.new do |yielder|
        CSV.foreach(file, DEFAULT_CSV_OPTIONS) do |row|
          yielder.yield(row)
        end
      end
    end

    def write(content, headers, output)
      csv_write_options = { col_sep: ', ', headers: :first_row, row_sep: "\r\n" }
      CSV.open(output, 'wb', csv_write_options) do |csv|
        csv << headers
        content.each do |row|
          csv << row
        end
      end
    end

    def sort(file, key)
      output = "#{file}.sorted"
      content_as_table = parse(file)
      headers = content_as_table.headers
      index_of_key = headers.index(key)
      content = content_as_table.sort_by { |a| -a[index_of_key].to_i }
      write(content, headers, output)
      output
    end

    def merge_records(merger, output)
      record = merger.next
      headers = record.keys
      contents = []
      merger.map { |e| contents << e }
      file_index = 0
      file_name = output.gsub('.txt', '')
      output_file = file_name + "_#{file_index}.txt"
      write(contents, headers, output_file)
    end
  end
end
