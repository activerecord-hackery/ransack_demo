# frozen_string_literal: true
class User < ApplicationRecord
  has_many :posts
  has_many :other_posts, class_name: "Post"
  has_many :comments
  has_and_belongs_to_many :roles

  # A ransack_alias gives a long attribute chain a short name: the simple search
  # form uses name_cont instead of first_name_or_last_name_cont.
  ransack_alias :name, :first_name_or_last_name

  # Scopes for the question in issue #6: a single grouping ANDs its conditions
  # on one joined row, so "posts.title = A AND posts.title = B" can never match.
  # Each scope filters on its own subquery, so two of them combine across
  # different posts: users with a post titled A and no post titled B.
  scope :with_post_titled, ->(title) { where(id: Post.where(title: title).select(:user_id)) }
  scope :without_post_titled, ->(title) { where.not(id: Post.where(title: title).select(:user_id)) }

  def datetime_format
    "%d/%m/%y %H:%M"
  end

  def created
    created_at.strftime(datetime_format)
  end

  def updated
    updated_at.strftime(datetime_format)
  end

  def self.postgres_version
    connection.execute("select version()").to_a.first["version"].first(16).strip
  end

  # Allowlist the User model attributes for sorting, except +password_digest+.
  # The +posts_count+ ransacker is sortable too; the +full_name+ ransacker is
  # not, as it adds nothing over +first_name+ in an ORDER BY.
  #
  def self.ransortable_attributes(auth_object = nil)
    column_names - ["password_digest"] + ["posts_count"]
  end

  # Allowlist the User model attributes for search, except +password_digest+,
  # as above. The ransackers below are included via +_ransackers.keys+, and
  # the +name+ alias via +_ransack_aliases.keys+.
  #
  def self.ransackable_attributes(auth_object = nil)
    ransortable_attributes + _ransackers.keys + _ransack_aliases.keys
  end

  # Allowlist the User model associations for search.
  #
  def self.ransackable_associations(auth_object = nil)
    ["posts", "other_posts", "comments", "roles"]
  end

  # Scopes must be allowlisted too before ransack will call them.
  #
  def self.ransackable_scopes(auth_object = nil)
    %i[with_post_titled without_post_titled]
  end

  # Demonstration of using a "ransacker" (a virtual, searchable "column") to
  # allow searching via the full name from concatenated first and last names.
  #
  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new("||",
      Arel::Nodes::InfixOperation.new("||",
        parent.table[:first_name], Arel::Nodes.build_quoted(" ")),
      parent.table[:last_name])
  end

  # A ransacker over a correlated subquery: the number of posts a user has.
  # Searchable (posts_count_gteq) and sortable (sort_link :posts_count), which
  # is the closest ransack answer to issue #2.
  #
  POSTS_COUNT_SQL = "(SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id)"

  ransacker :posts_count, type: :integer do
    Arel.sql(POSTS_COUNT_SQL)
  end

  # Also select the count, so it is available as +user.posts_count+ and so
  # PostgreSQL accepts ORDER BY posts_count together with DISTINCT (an ORDER BY
  # expression must appear in the select list of a SELECT DISTINCT).
  scope :with_posts_count, -> { select("users.*", "#{POSTS_COUNT_SQL} AS posts_count") }
end
