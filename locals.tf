locals {
  subnet_name = coalesce(var.custom_bastion_subnet_name, "bastion-${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-subnet")
}