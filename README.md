# Ransack Demo Application

This is a quick demonstration of how you might use [Ransack](https://github.com/activerecord-hackery/ransack)
in a Rails 3.1 application to create an "advanced" search form, with nesting, etc.

This isn't quite as polished as I'd like it to be, but I thought it would be best to
get it up on GitHub in its current state since I've had some requests for the code.

I'll clean it up and add to it as Ransack evolves.

In the meantime, the main things you'll want to note are:

* app/models/user.rb - Demonstration of using a "ransacker" (a virtual, searchable "column")
  to allow searching via full name, from concatenated first and last names.
* app/views/users/ - Search form and various partials used in dynamic form.
* app/helpers/application_helper.rb - `setup_search_form`, which creates a Javascript search
  object with a grouping template, since we can't dynamically create grouping templates in
  ruby (groupings can contain other groupings, would end up in infinite recursion). The rest
  of the methods in here are pretty much the same as nested field helpers in Ryan Bates'
  [Railscast #197](http://railscasts.com/episodes/197-nested-model-form-part-2).
* app/assets/javascripts/search.js.coffee - CoffeeScript to handle addition/removal of fields,
  as well as nesting fields (adding a grouping from the previously mentioned grouping template)
  
Let me know if you have any questions, and happy ransacking!