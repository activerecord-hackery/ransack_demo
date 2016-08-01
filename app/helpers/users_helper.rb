# frozen_string_literal: true
module UsersHelper
  def model_fields
    # which fields to display and sort by
    %i(id first_name last_name email).freeze
  end

  def results_limit
    # max number of search results to display
    10
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
    model_fields.reduce(String.new) do |string, field|
      string << (tag.th sort_link(search, field, {}, method: action))
    end
  end

  def display_search_results(objects)
    objects.limit(results_limit).reduce(String.new) do |string, object|
      string << (tag.tr display_search_results_row(object))
    end
  end

  def display_search_results_row(object)
    model_fields.reduce(String.new) do |string, field|
      string << (tag.td object.send(field))
    end
    .html_safe
  end
end
