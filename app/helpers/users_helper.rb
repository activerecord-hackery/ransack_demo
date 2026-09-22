module UsersHelper
  def user_column_headers
    %i[id first_name last_name email created_at updated_at].freeze
  end

  # Max number of search results to display.
  def results_limit
    10
  end

  # Associations offered in the advanced search's attribute select. An entry
  # such as posts_tags reaches through an association, giving posts_tags_name.
  def searchable_associations
    %w[posts posts_tags other_posts other_posts_tags comments roles].freeze
  end

  # Attributes whose values come from a short, known list. The advanced search
  # offers these as a select instead of a free-text field.
  def value_options
    tag_names = Tag.order(:name).pluck(:name)
    {
      "roles_name" => Role.order(:name).pluck(:name),
      "posts_tags_name" => tag_names,
      "other_posts_tags_name" => tag_names
    }
  end

  # The attribute of the condition a value field belongs to.
  def condition_attribute(value_builder)
    value_builder.options[:parent_builder].object.attributes.first&.name
  end

  # Templates the search controller clones when the attribute of a condition
  # changes: a plain text input, and one select per attribute in value_options.
  def value_field_templates
    input = tag.template text_field_tag("value", nil, class: [input_classes, "w-40"], placeholder: "Value"),
      data: {search_target: "valueInput"}
    selects = value_options.map do |attribute, options|
      tag.template select_tag("value", options_for_select(options), include_blank: true, class: select_classes),
        data: {search_target: "valueOptions", attribute: attribute}
    end
    safe_join([input, *selects])
  end

  def user_wants_distinct_results?
    params[:distinct].to_i == 1
  end

  def results_header(count)
    if count > results_limit
      "Your first #{results_limit} results out of #{count} total"
    else
      "Your #{pluralize(count, "result")}"
    end
  end

  def sort_header(search, field)
    sort_link search, field, class: "group inline-flex items-center gap-1 text-gray-900 hover:text-indigo-600"
  end
end
