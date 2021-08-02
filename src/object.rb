class Object
  def nan?
    self.is_a?(Float) and self.nan?
  end
end