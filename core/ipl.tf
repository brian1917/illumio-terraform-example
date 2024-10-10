resource "illumio-core_ip_list" "Azure" {
  name        = "Azure"
  description = ""
 
  fqdns {
      fqdn = "*azure.com"
      description = ""
  }
 
  fqdns {
      fqdn = "dc.services.visualstudio.com"
      description = ""
  }

  ip_ranges {
    from_ip = "127.0.0.1"
    description = "placeholder for provider requiring ip_ranges. illumio pce IP"
  }
}

