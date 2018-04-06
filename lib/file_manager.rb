# Manage File operations
class FileManager
  class << self
    def latest(name)
      fetch_files(name)
      @files.sort_by! do |file|
        last_date = file.scan(/\d+-\d+-\d+/).last
        DateTime.parse(last_date.to_s)
      end
      @files.last
    end

    def fetch_files(name)
      @files = Dir.glob("./workspace/*#{name}*.txt")
                  .select { |v| /\d+-\d+-\d+_[[:alpha:]]+\.txt$/.match v }

      throw RuntimeError if @files.empty?
      @files
    end
  end
end
