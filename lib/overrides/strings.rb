# Adding methods to String class
class String
  # Replae ',' with '.' and convert to float
  def from_german_to_f
    tr(',', '.').to_f
  end
end
