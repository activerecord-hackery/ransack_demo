# frozen_string_literal: true
module UsersHelper
  def link_to_toggle_search_modes
    if action_name == 'advanced_search'
      link_to('Go to Simple mode', users_path)
    else
      link_to('Go to Advanced mode', advanced_search_users_path)
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

  def user_wants_distinct_results?
    params[:distinct].to_i == 1
  end

  def display_distinct_label_and_check_box
    tag.section do
      check_box_tag(:distinct, '1', user_wants_distinct_results?) +
      label_tag(:distinct, 'Return distinct records')
    end
  end

  def display_query_sql(users)
    tag.p('SQL:') + tag.code(users.to_sql)
  end

  def display_results_header(count)
    if count > results_limit
      "Your first #{results_limit} results out of #{count} total"
    else
      "Your #{pluralize(count, 'result')}"
    end
  end

  def action
    if action_name == 'advanced_search'
      :post
    else
      :get
    end
  end

  def display_sort_column_headers(search)
    user_column_headers.reduce(String.new) do |string, field|
      string << (tag.th sort_link(search, field, {}, method: action))
    end +
    post_title_header_labels.reduce(String.new) do |str, i|
      str << (tag.th "Post #{i} title")
    end
  end

  def display_search_results(objects)
    objects.limit(results_limit).reduce(String.new) do |string, object|
      string << (tag.tr display_search_results_row(object))
    end
  end

  def display_search_results_row(object)
    user_column_fields.reduce(String.new) do |string, field|
      string << (tag.td object.send(field))
    end
    .html_safe +
    display_user_posts(object.posts)
  end

  def display_user_posts(posts)
    posts.reduce(String.new) do |string, post|
      string << (tag.td truncate(post.title, length: post_title_length))
    end
    .html_safe
  end
end
