# Adding methods to Array class
class Array
  # To remove quotation marks from hash result string
  def to_readable_value
    value = join(', ').tr('"', '')
    value.empty? ? nil : value
  end
end
