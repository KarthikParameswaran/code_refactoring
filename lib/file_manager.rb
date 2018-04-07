# Manage File operations
class FileManager
  class << self
    # Fetch the lastest from the array of files
    def latest(name)
      fetch_files(name)
      @files.sort_by! do |file|
        last_date = file.scan(/\d+-\d+-\d+/).last
        Date.parse(last_date.to_s)
      end
      @files.last
    end

    # Fetch all files with a specific substring file name
    def fetch_files(name)
      @files = Dir.glob("./workspace/*#{name}*.txt")
                  .select { |v| /\d+-\d+-\d+_[[:alpha:]]+\.txt$/.match v }

      throw RuntimeError if @files.empty?
      @files
    end
  end
end
