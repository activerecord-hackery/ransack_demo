this.Search = (function() {
  function Search(templates) {
    this.templates = templates != null ? templates : {};
  }

  Search.prototype.remove_fields = function(button) {
    return $(button).closest('.fields').remove();
  };

  Search.prototype.add_fields = function(button, type, content) {
    var new_id, regexp;
    new_id = new Date().getTime();
    regexp = new RegExp('new_' + type, 'g');
    return $(button).before(content.replace(regexp, new_id));
  };

  Search.prototype.nest_fields = function(button, type) {
    var id_regexp, new_id, object_name, sanitized_object_name, template;
    new_id = new Date().getTime();
    id_regexp = new RegExp('new_' + type, 'g');
    template = this.templates[type];
    object_name = $(button).closest('.fields').attr('data-object-name');
    sanitized_object_name = object_name.replace(/\]\[|[^-a-zA-Z0-9:.]/g, '_').replace(/_$/, '');
    template = template.replace(/new_object_name\[/g, object_name + "[");
    template = template.replace(/new_object_name_/, sanitized_object_name + '_');
    return $(button).before(template.replace(id_regexp, new_id));
  };

  return Search;

})();
