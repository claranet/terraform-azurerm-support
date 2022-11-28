# v7.1.0 - 2022-11-28

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)
  * AZ-908: Bump submodules `subnet`, `nsg` and `bastion-vm`

# v7.0.0 - 2022-10-07

Breaking
  * AZ-840: Update to Terraform `v1.3`

Added
  * AZ-825 AZ-814 AZ-818: Bump `linux-vm/bastion-vm` modules and include all its new features
  * AZ-825 AZ-814 AZ-818: Bump `subnet/nsg` modules and include all their new features

Changed
  * AZ-825 AZ-814 AZ-818: No more default private IP & subnet CIDR, variables must be set

# v6.0.1 - 2022-06-10

Added
  * AZ-770: Add Terraform module info in output

# v6.0.0 - 2022-05-20

Breaking
  * AZ-717: Bump module and `linux-vm` module for AzureRM provider `v3.0+`

# v5.2.0 - 2022-05-13

Added
  * AZ-711: Add `storage_image_id` parameter to provision the bastion VM with a custom image

# v5.1.0 - 2022-04-29

Added
  * AZ-615: Add an option to enable or disable default tags

Changed
  * AZ-614: Optional OS disk tagging

# v5.0.0 - 2022-01-13

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

# v4.2.0 - 2021-10-19

Breaking
  * AZ-492: Refactor SSH keys management

Added
  * AZ-573: Allow Vnet in separate resource group
  * AZ-561: Allow to deploy Bastion VM without public IP

Changed
  * AZ-572: Revamp examples and improve CI

# v4.1.0 - 2021-08-20

Updated
  * AZ-532: Revamp README with latest `terraform-docs` tool
  * AZ-530: Cleanup module, fix linter errors

# v3.2.0/v4.0.0 - 2020-12-31

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

Breaking
  * AZ-273: Upgrade sub-modules version to `v4.0.0` (ref: changelog for subnet, nsg, bastion-vm, linux-vm).

# v3.1.0 - 2020-08-24

Added
  * AZ-255: Allow to customize subnet and nsg, ipconfig, nic names

# v3.0.0 - 2020-07-30

Breaking
  * AZ-198: Upgrade AzureRM version for compatibility with > 2.0
  * AZ-236: Use `bastion` module reworked and based on `linux-vm`

Changed
  * AZ-209: Update CI with Gitlab template

# v2.2.0 - 2020-07-03

Added
  * AZ-231: Add `name_prefix` variable on nsg submodule

# v2.1.0 - 2020-01-31

Changed
  * AZ-168: Bastion refactoring and fixes, also new outputs

# v2.0.0 - 2019-12-30

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

Changed
  * AZ-165: Upgrade versions of subnet and bastion-vm modules to remove warnings

# v1.0.0 - 2019-07-01

Added
  * AZ-37: First release
