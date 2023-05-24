resource "illumio-core_label" "illumio_labels" {
  for_each = local.illumio_labels_json
  key   =  each.value["key"]
  value = each.value["value"]
}
