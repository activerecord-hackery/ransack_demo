module PostsMixin
  def ransackable_attributes(_auth_object)
    ["title"]
  end
end
