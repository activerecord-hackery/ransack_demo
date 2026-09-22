# Ransack Demo Application

This is a quick demonstration of how you might use
[Ransack](https://github.com/activerecord-hackery/ransack) in a Rails 8
application to create an "advanced" search form, with nesting, etc.

![Simple search](docs/screenshots/simple-search.png)

![Advanced search](docs/screenshots/advanced-search.png)

The main things you'll want to note are:

* app/models/user.rb - Demonstration of:
  - using a "ransacker" (a virtual, searchable "column") to allow searching on
    full names from concatenated first and last names.
  - whitelisting attributes allowed for searching using `ransackable_attributes`.
  - whitelisting attributes allowed for sorting using `ransortable_attributes`.
* app/views/users/ - Search form and various partials used in dynamic form.
* app/helpers/application_helper.rb - `grouping_template`, which renders the
  condition-group fields once into a `<template>`, since we can't dynamically
  create grouping templates in Ruby (groupings can contain other groupings,
  would end up in infinite recursion). `button_to_add_fields` renders each set
  of fields into a `<template>` next to its button, much like the nested field
  helpers in Ryan Bates'
  [Railscast #197](http://railscasts.com/episodes/197-nested-model-form-part-2).
* app/javascript/controllers/search_controller.js - a Stimulus controller that
  adds and removes fields, and nests groupings by re-parenting the grouping
  template.

The UI is [Tailwind CSS](https://tailwindcss.com) via `tailwindcss-rails`, with
JavaScript served through import maps; there is no Node toolchain.

## Running locally

```sh
bin/setup        # bundle, create and seed the PostgreSQL database, start the server
bin/rails test   # unit and integration tests
bin/rails test:system   # browser tests of the dynamic form (needs Chrome)
```

Let us know if you have any questions, and happy ransacking!
