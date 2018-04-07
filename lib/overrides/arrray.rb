# Adding methods to Array class
class Array
  def to_readable_value
    value = join(', ').tr('"', '')
    value.empty? ? nil : value
  end
end
