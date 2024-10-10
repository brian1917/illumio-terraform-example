locals {
   illumio_labels_json   = jsondecode(file("input_files/labels.json"))
   illumio_unmanaged_wklds_json  = jsondecode(file("input_files/unmanaged_workloads.json"))
}
