class Search {
  constructor(templates = {}) {
    this.templates = templates;
  }

  remove_fields(button) {
    return $(button).closest('.fields').remove();
  }

  add_fields(button, type, content) {
    const new_id = new Date().getTime();
    const regexp = new RegExp('new_' + type, 'g');
    return $(button).before(content.replace(regexp, new_id));
  }

  nest_fields(button, type) {
    const new_id = new Date().getTime();
    const id_regexp = new RegExp('new_' + type, 'g');
    const template = this.templates[type];
    const object_name = $(button).closest('.fields').attr('data-object-name');
    const sanitized_object_name = object_name.replace(/\]\[|[^-a-zA-Z0-9:.]/g, '_').replace(/_$/, '');
    let updated_template = template.replace(/new_object_name\[/g, object_name + "[");
    updated_template = updated_template.replace(/new_object_name_/, sanitized_object_name + '_');
    return $(button).before(updated_template.replace(id_regexp, new_id));
  }
}

// Make Search available globally
window.Search = Search;

export default Search;