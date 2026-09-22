Ransack.configure do |config|
  # A custom predicate. created_at_lteq_end_of_day takes a date and widens it
  # to the last moment of that day, so a "to" date in a range is inclusive.
  # The value is cast to :datetime before the formatter runs.
  config.add_predicate "lteq_end_of_day",
    arel_predicate: "lteq",
    formatter: ->(value) { value.end_of_day },
    validator: ->(value) { value.present? },
    type: :datetime
end
