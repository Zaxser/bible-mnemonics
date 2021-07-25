class Array
  def fields(label="name")
    self.map {|element| {label => element}}
  end
end