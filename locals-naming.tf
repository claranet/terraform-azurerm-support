locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  avset_name = coalesce(data.azurecaf_name.avset.result, var.custom_availability_set_name)
}
