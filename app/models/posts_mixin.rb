module PostsMixin
  def ransackable_attributes(_auth_object = nil)
    ["title"]
  end
end
