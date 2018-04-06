# Adding methods to Float class
class Float
  def to_german_s
    to_s.tr('.', ',')
  end
end
