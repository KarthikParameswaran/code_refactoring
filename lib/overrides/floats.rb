# Adding methods to Float class
class Float
  # Replace '.' with ','
  def to_german_s
    to_s.tr('.', ',')
  end
end
