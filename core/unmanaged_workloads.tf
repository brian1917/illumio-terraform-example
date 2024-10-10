# # Create unmanaged workloads in Illumio 
# resource "illumio-core_unmanaged_workload" "illumio_unmanaged_workload" { 
#   for_each = local.illumio_unmanaged_wklds_json
#   name = each.value["name"]
#   hostname = each.value["hostname"]
#   interfaces { 
#     name = each.value["interfaces"].name
#     address = each.value["interfaces"].address
#     cidr_block = each.value["interfaces"].cidr_block
#     } 
    
#   dynamic "labels" {
#   for_each = each.value["labels"]
#     content {
#       href = illumio-core_label.illumio_labels[format("%s:%s",labels.value.key,labels.value.value)].href
#     }
#   }
# }

