# Adding methods to String class
class String
  def from_german_to_f
    tr(',', '.').to_f
  end
end
