# __generated__ by OpenTofu
# Please review these resources and move them into your main configuration files.

# __generated__ by OpenTofu from "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-db-zyb6/providers/Microsoft.Network/privateDnsZones/geniac-staging-db-zyb6-dns.postgres.database.azure.com/virtualNetworkLinks/geniac-staging-db-zyb6"
resource "azurerm_private_dns_zone_virtual_network_link" "main-1" {
  name                  = "geniac-staging-db-zyb6"
  private_dns_zone_name = "geniac-staging-db-zyb6-dns.postgres.database.azure.com"
  registration_enabled  = false
  resource_group_name   = "geniac-staging-db-zyb6"
  tags = {
    managed-by  = "massdriver"
    md-manifest = "db"
    md-package  = "geniac-staging-db-zyb6"
    md-project  = "geniac"
    md-target   = "staging"
  }
  virtual_network_id = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-network-r6cm/providers/Microsoft.Network/virtualNetworks/geniac-staging-network-r6cm"
}

# __generated__ by OpenTofu
resource "azurerm_virtual_network" "main" {
  address_space           = ["10.9.0.0/16"]
  bgp_community           = null
  dns_servers             = []
  edge_zone               = null
  flow_timeout_in_minutes = null
  location                = "eastus"
  name                    = "geniac-staging-network-r6cm"
  resource_group_name     = "geniac-staging-network-r6cm"

  tags = {
    managed-by  = "massdriver"
    md-manifest = "network"
    md-package  = "geniac-staging-network-r6cm"
    md-project  = "geniac"
    md-target   = "staging"
  }
}

# __generated__ by OpenTofu from "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-database-mc1p/providers/Microsoft.Network/privateDnsZones/geniac-staging-database-mc1p-dns.postgres.database.azure.com/virtualNetworkLinks/geniac-staging-database-mc1p"
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "geniac-staging-database-mc1p"
  private_dns_zone_name = "geniac-staging-database-mc1p-dns.postgres.database.azure.com"
  registration_enabled  = false
  resource_group_name   = "geniac-staging-database-mc1p"
  tags = {
    managed-by  = "massdriver"
    md-manifest = "database"
    md-package  = "geniac-staging-database-mc1p"
    md-project  = "geniac"
    md-target   = "staging"
  }
  virtual_network_id = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-network-r6cm/providers/Microsoft.Network/virtualNetworks/geniac-staging-network-r6cm"
}

# __generated__ by OpenTofu from "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-database-mc1p/providers/Microsoft.DBforPostgreSQL/flexibleServers/geniac-staging-database-mc1p"
resource "azurerm_postgresql_flexible_server" "main" {
  administrator_login               = "cory"
  administrator_password            = null # sensitive
  auto_grow_enabled                 = false
  backup_retention_days             = 7
  create_mode                       = null
  delegated_subnet_id               = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-network-r6cm/providers/Microsoft.Network/virtualNetworks/geniac-staging-network-r6cm/subnets/geniac-staging-database-mc1p"
  geo_redundant_backup_enabled      = true
  location                          = "eastus"
  name                              = "geniac-staging-database-mc1p"
  point_in_time_restore_time_in_utc = null
  private_dns_zone_id               = "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-database-mc1p/providers/Microsoft.Network/privateDnsZones/geniac-staging-database-mc1p-dns.postgres.database.azure.com"
  replication_role                  = null
  resource_group_name               = "geniac-staging-database-mc1p"
  sku_name                          = "GP_Standard_D2ds_v4"
  source_server_id                  = null
  storage_mb                        = 32768
  storage_tier                      = "P4"
  tags = {
    managed-by  = "massdriver"
    md-manifest = "database"
    md-package  = "geniac-staging-database-mc1p"
    md-project  = "geniac"
    md-target   = "staging"
  }
  version = "16"
  zone    = "3"
  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
    tenant_id                     = null
  }
}

# __generated__ by OpenTofu from "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-db-zyb6/providers/Microsoft.Network/privateDnsZones/geniac-staging-db-zyb6-dns.postgres.database.azure.com"
resource "azurerm_private_dns_zone" "main-1" {
  name                = "geniac-staging-db-zyb6-dns.postgres.database.azure.com"
  resource_group_name = "geniac-staging-db-zyb6"
  tags = {
    managed-by  = "massdriver"
    md-manifest = "db"
    md-package  = "geniac-staging-db-zyb6"
    md-project  = "geniac"
    md-target   = "staging"
  }
  soa_record {
    email        = "azureprivatedns-host.microsoft.com"
    expire_time  = 2419200
    minimum_ttl  = 10
    refresh_time = 3600
    retry_time   = 300
    tags         = {}
    ttl          = 3600
  }
}

# __generated__ by OpenTofu from "/subscriptions/4718857a-5dbe-452c-a172-21a3ae74304f/resourceGroups/geniac-staging-database-mc1p/providers/Microsoft.Network/privateDnsZones/geniac-staging-database-mc1p-dns.postgres.database.azure.com"
resource "azurerm_private_dns_zone" "main" {
  name                = "geniac-staging-database-mc1p-dns.postgres.database.azure.com"
  resource_group_name = "geniac-staging-database-mc1p"
  tags = {
    managed-by  = "massdriver"
    md-manifest = "database"
    md-package  = "geniac-staging-database-mc1p"
    md-project  = "geniac"
    md-target   = "staging"
  }
  soa_record {
    email        = "azureprivatedns-host.microsoft.com"
    expire_time  = 2419200
    minimum_ttl  = 10
    refresh_time = 3600
    retry_time   = 300
    tags         = {}
    ttl          = 3600
  }
}
