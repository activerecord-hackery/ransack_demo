import { Controller } from "@hotwired/stimulus"

// Adds, removes and nests the field groups of the advanced search form.
//
// Rails renders each set of fields once, into a <template>, with a placeholder
// index (new_condition, new_value, new_sort, new_grouping). When a template is
// inserted the placeholder is swapped for a timestamp so that every set of
// fields ends up with its own index in the submitted params.
//
// Groupings can contain other groupings, which Ruby cannot render recursively
// without an infinite loop, so a single grouping template is rendered once
// under the object name "new_object_name" and re-parented here on each nest.
export default class extends Controller {
  static targets = ["groupingTemplate"]

  add(event) {
    const button = event.currentTarget
    const template = button.previousElementSibling
    button.insertAdjacentHTML("beforebegin", this.stamp(template.innerHTML, event.params.type))
  }

  remove(event) {
    event.currentTarget.closest("[data-fields]").remove()
  }

  nest(event) {
    const button = event.currentTarget
    const objectName = button.closest("[data-fields]").dataset.objectName
    const sanitizedObjectName = objectName.replace(/\]\[|[^-a-zA-Z0-9:.]/g, "_").replace(/_$/, "")
    const html = this.groupingTemplateTarget.innerHTML
      .replace(/new_object_name\[/g, `${objectName}[`)
      .replace(/new_object_name_/g, `${sanitizedObjectName}_`)
    button.insertAdjacentHTML("beforebegin", this.stamp(html, "grouping"))
  }

  // Only some predicates (in, not_in, *_any, *_all) accept several values. A
  // condition that pairs a single-value predicate with several values is
  // invalid and ransack drops it, so the form would appear to reset. Keep the
  // "Add Value" button in step with the predicate and trim surplus values.
  predicateChanged(event) {
    const select = event.currentTarget
    const multi = select.dataset.multiValuePredicates.split(" ").includes(select.value)
    const condition = select.closest("[data-fields=condition]")
    const button = condition.querySelector("button[data-search-type-param=value]")
    button.disabled = !multi
    if (multi) return
    condition.querySelectorAll("[data-fields=value]").forEach((value, index) => {
      if (index > 0) value.remove()
    })
  }

  stamp(html, type) {
    return html.replace(new RegExp(`new_${type}`, "g"), Date.now())
  }
}
