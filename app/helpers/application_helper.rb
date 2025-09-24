# frozen_string_literal: true
module ApplicationHelper
  def setup_search_form(builder)
    fields = builder.grouping_fields builder.object.new_grouping,
      object_name: "new_object_name", child_index: "new_grouping" do |f|
      render("grouping_fields", f: f)
    end
    content_for :document_ready, %Q{
      var search = new Search({grouping: "#{escape_javascript(fields)}"});
      $(document).on("click", "button.add_fields", function() {
        search.add_fields(this, $(this).data('fieldType'), $(this).data('content'));
        return false;
      });
      $(document).on("click", "button.remove_fields", function() {
        search.remove_fields(this);
        return false;
      });
      $(document).on("click", "button.nest_fields", function() {
        search.nest_fields(this, $(this).data('fieldType'));
        return false;
      });
    }.html_safe
  end

  def button_to_remove_fields
    tag.button "Remove", 
      class: "remove_fields inline-flex items-center px-3 py-1 border border-red-300 shadow-sm text-xs font-medium rounded text-red-700 bg-white hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
  end

  def button_to_add_fields(f, type)
    new_object, name = f.object.send("build_#{type}"), "#{type}_fields"
    fields = f.send(name, new_object, child_index: "new_#{type}") do |builder|
      render(name, f: builder)
    end

    tag.button button_label[type], 
      class: "add_fields inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500", 
      'data-field-type': type,
      'data-content': "#{fields}"
  end

  def button_to_nest_fields(type)
    tag.button button_label[type], 
      class: "nest_fields inline-flex items-center px-3 py-1 border border-purple-300 shadow-sm text-xs font-medium rounded text-purple-700 bg-purple-50 hover:bg-purple-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500", 
      'data-field-type': type
  end

  def button_label
    { value:     "Add Value",
      condition: "Add Condition",
      sort:      "Add Sort",
      grouping:  "Add Condition Group" }.freeze
  end

  def app_info
    @@app_info ||= "#{
      tag.strong 'Ransack demo app'
      } running on Ruby #{RUBY_VERSION}, Rails #{Rails::VERSION::STRING
      } and #{User.postgres_version} - #{source_code_link}".html_safe
  end

  def source_code_link
    link_to "Source code for this demo available on GitHub",
      "https://github.com/activerecord-hackery/ransack_demo"
  end
end
