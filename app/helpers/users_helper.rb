module UsersHelper
  def user_column_headers
    %i[id first_name last_name email created_at updated_at].freeze
  end

  # Max number of search results to display.
  def results_limit
    10
  end

  def user_posts_and_comments
    %w[posts other_posts comments].freeze
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
