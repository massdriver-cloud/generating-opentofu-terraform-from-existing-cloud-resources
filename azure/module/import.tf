
import {
  id = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-database-mc1p/providers/Microsoft.DBforPostgreSQL/flexibleServers/geniac-staging-database-mc1p"
  to = azurerm_postgresql_flexible_server.main
}

import {
  id = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-database-mc1p/providers/Microsoft.Network/privateDnsZones/geniac-staging-database-mc1p-dns.postgres.database.azure.com"
  to = azurerm_private_dns_zone.main
}

import {
  id = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-database-mc1p/providers/Microsoft.Network/privateDnsZones/geniac-staging-database-mc1p-dns.postgres.database.azure.com/virtualNetworkLinks/geniac-staging-database-mc1p"
  to = azurerm_private_dns_zone_virtual_network_link.main
}

import {
  id = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-db-zyb6/providers/Microsoft.Network/privateDnsZones/geniac-staging-db-zyb6-dns.postgres.database.azure.com"
  to = azurerm_private_dns_zone.main-1
}

import {
  id = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-db-zyb6/providers/Microsoft.Network/privateDnsZones/geniac-staging-db-zyb6-dns.postgres.database.azure.com/virtualNetworkLinks/geniac-staging-db-zyb6"
  to = azurerm_private_dns_zone_virtual_network_link.main-1
}

import {
  id = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-network-r6cm/providers/Microsoft.Network/virtualNetworks/geniac-staging-network-r6cm"
  to = azurerm_virtual_network.main
}
