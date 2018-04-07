#
# Manage CSV Operation
#
class CsvManager
  DEFAULT_CSV_OPTIONS = { col_sep: ' | ', headers: :first_row }.freeze
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
      csv_write_options = { col_sep: ' | ', headers: :first_row, row_sep: "\r\n" }
      CSV.open(output, 'wb', csv_write_options) do |csv|
        csv << headers
        content.each do |row|
          csv << row
        end
      end
    end

    def sort(file, key)
      output = "#{file}.sorted"
      @headers = []
      @content = []
      read_file_content(file, key)
      write(@content, @headers, output)
      output
    end

    def sort_multiple(output, files, key)
      output_file = "#{output}.sorted"
      @headers = []
      @content = []
      files.each do |file|
        @content_as_table = parse(file)
        @headers = @content_as_table.headers if @headers.empty?
        @index_of_key = @headers.index(key)
        @content += @content_as_table.to_a.drop(1)
      end
      @content = @content.sort_by { |a| -a[@index_of_key].to_i }
      write(@content, @headers, output_file)
      output_file
    end

    def merge_records(merger, output)
      contents = []
      flag = true
      while flag
        begin
          record   = merger.next
          headers  = record.keys if headers.nil?
          contents << record
        rescue StopIteration
          flag = false
          break
        end
      end
      file_name = output.gsub('.txt', '')
      output_file = file_name + '.txt.audited'
      write(contents, headers, output_file)
    end

    private

    # Shared method for reading file content
    def read_file_content(file, key)
      @content_as_table = parse(file)
      @headers = @content_as_table.headers if @headers.empty?
      index_of_key = @headers.index(key)
      @content += @content_as_table.sort_by { |a| -a[index_of_key].to_i }
    end
  end
end
