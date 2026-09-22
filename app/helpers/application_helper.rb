module ApplicationHelper
  INPUT_CLASSES = "block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 " \
    "outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 " \
    "focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6".freeze

  SELECT_CLASSES = "rounded-md bg-white py-1.5 pr-8 pl-3 text-base text-gray-900 " \
    "outline-1 -outline-offset-1 outline-gray-300 " \
    "focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6".freeze

  BUTTON_CLASSES = {
    primary: "rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-xs " \
      "hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600",
    secondary: "rounded-md bg-white px-2.5 py-1.5 text-sm font-semibold text-gray-900 shadow-xs " \
      "ring-1 ring-gray-300 ring-inset hover:bg-gray-50",
    danger: "text-sm font-semibold text-red-600 hover:text-red-500"
  }.freeze

  def input_classes
    INPUT_CLASSES
  end

  def select_classes
    SELECT_CLASSES
  end

  def button_classes(variant)
    BUTTON_CLASSES.fetch(variant)
  end

  # Renders the grouping template used by the search Stimulus controller to
  # nest a condition group inside another. Groupings can contain groupings, so
  # this cannot be rendered recursively in Ruby; it is rendered once, under a
  # placeholder object name, and re-parented in JavaScript.
  def grouping_template(builder)
    fields = builder.grouping_fields builder.object.new_grouping,
      object_name: "new_object_name", child_index: "new_grouping" do |f|
      render("grouping_fields", f: f)
    end
    tag.template fields, data: {search_target: "groupingTemplate"}
  end

  def button_to_remove_fields
    tag.button "Remove", type: "button", class: button_classes(:danger),
      data: {action: "search#remove"}
  end

  # A <template> holding a fresh set of fields for +type+, followed by the
  # button that inserts a stamped copy of it.
  def button_to_add_fields(f, type)
    new_object = f.object.send("build_#{type}")
    name = "#{type}_fields"
    fields = f.send(name, new_object, child_index: "new_#{type}") do |builder|
      render(name, f: builder)
    end

    tag.template(fields) +
      tag.button(button_label[type], type: "button", class: button_classes(:secondary),
        data: {action: "search#add", search_type_param: type})
  end

  def button_to_nest_fields
    tag.button button_label[:nest], type: "button", class: button_classes(:secondary),
      data: {action: "search#nest"}
  end

  def button_label
    {value: "Add Value",
     condition: "Add Condition",
     sort: "Add Sort",
     grouping: "Add Condition Group",
     nest: "Add Nested Group"}.freeze
  end

  def app_info
    safe_join([
      tag.strong("Ransack demo app"),
      " running Ransack #{Ransack::VERSION} on Ruby #{RUBY_VERSION}, Rails #{Rails::VERSION::STRING} and #{User.postgres_version}. ",
      source_code_link
    ])
  end

  def nav_link(label, path)
    active = current_page?(path)
    link_to label, path, class: [
      "rounded-md px-3 py-2 text-sm font-medium",
      active ? "bg-indigo-50 text-indigo-700" : "text-gray-600 hover:bg-gray-100 hover:text-gray-900"
    ], "aria-current": (active ? "page" : nil)
  end

  def source_code_link
    link_to "Source code on GitHub", "https://github.com/activerecord-hackery/ransack_demo",
      class: "font-medium text-indigo-600 hover:text-indigo-500"
  end
end
