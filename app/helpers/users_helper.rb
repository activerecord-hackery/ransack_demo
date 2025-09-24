# frozen_string_literal: true
module UsersHelper
  def action
    if action_name == "advanced_search"
      :post
    else
      :get
    end
  end

  def link_to_toggle_search_modes
    if action_name == "advanced_search"
      link_to("← Simple Search", users_path, 
        class: "inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500")
    else
      link_to("Advanced Search →", advanced_search_users_path, 
        class: "inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500")
    end
  end

  def user_column_headers
    %i(id first_name last_name email created_at updated_at).freeze
  end

  def user_column_fields
    %i(id first_name last_name email created updated).freeze
  end

  def results_limit
    # max number of search results to display
    10
  end

  def post_title_length
    # max number of characters in posts titles to display
    14
  end

  def post_title_header_labels
    %w(1 2 3).freeze
  end

  def user_posts_and_comments
    %w(posts other_posts comments).freeze
  end

  def condition_fields
    %w(fields condition).freeze
  end

  def value_fields
    %w(fields value).freeze
  end

  def display_distinct_label_and_check_box
    tag.div(class: "flex items-center space-x-2") do
      check_box_tag(:distinct, "1", user_wants_distinct_results?, 
        class: "h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded") +
      label_tag(:distinct, "Return distinct records", 
        class: "text-sm font-medium text-gray-700")
    end
  end

  def user_wants_distinct_results?
    params[:distinct].to_i == 1
  end

  def display_query_sql(users)
    tag.p("SQL:") + tag.code(users.to_sql)
  end

  def display_results_header(count)
    if count > results_limit
      "Your first #{results_limit} results out of #{count} total"
    else
      "Your #{pluralize(count, 'result')}"
    end
  end

  def display_sort_column_headers(search)
    user_column_headers.reduce(String.new) do |string, field|
      string << (tag.th sort_link(search, field, method: action), 
        class: "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100")
    end +
    post_title_header_labels.reduce(String.new) do |str, i|
      str << (tag.th "Post #{i} title", 
        class: "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider")
    end
  end

  def display_search_results(objects)
    objects.limit(results_limit).reduce(String.new) do |string, object|
      string << (tag.tr display_search_results_row(object), 
        class: "hover:bg-gray-50")
    end
  end

  def display_search_results_row(object)
    user_column_fields.reduce(String.new) do |string, field|
      string << (tag.td object.send(field), 
        class: "px-6 py-4 whitespace-nowrap text-sm text-gray-900")
    end
    .html_safe +
    display_user_posts(object.posts)
  end

  def display_user_posts(posts)
    posts.reduce(String.new) do |string, post|
      string << (tag.td truncate(post.title, length: post_title_length), 
        class: "px-6 py-4 whitespace-nowrap text-sm text-gray-500")
    end
    .html_safe
  end
end
