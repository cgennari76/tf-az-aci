resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "myFWPublicIPAddress" {
  name                = "fw-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "myFirewall" {
  name                = "myFirewall"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.myFWPublicIPAddress.id
  }
}

resource "azurerm_route_table" "rt-table" {
  name                          = "rt-table"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.myFirewall.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_firewall_nat_rule_collection" "myFirewall" {
  name                = "myNATCollection"
  azure_firewall_name = azurerm_firewall.myFirewall.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "myRule"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "443",
    ]

    destination_addresses = [
      azurerm_public_ip.myFWPublicIPAddress.ip_address
    ]
    
    translated_port = 443

    translated_address = azurerm_container_group.ssl-frontend.ip_address
    
    protocols = [
      "TCP"
    ]
  }
}

resource "azurerm_subnet_route_table_association" "myFirewall" {
  subnet_id       = azurerm_subnet.gateway.id
  route_table_id = azurerm_route_table.rt-table.id
}

