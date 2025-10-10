## 8.3.0 (2025-10-10)

### Features

* ✨ add name_suffix to subnet 67590c5

### Miscellaneous Chores

* **deps:** update dependency trivy to v0.67.1 71eef24

## 8.2.4 (2025-10-01)

### Code Refactoring

* **deps:** 🔗 update claranet/azurecaf to ~> 1.3.0 🔧 f137aac

### Miscellaneous Chores

* **⚙️:** ✏️ update template identifier for MR review a091f00
* 🗑️ remove old commitlint configuration files 88f1130
* **deps:** 🔗 bump AzureRM provider version to v4.31+ 716e9b5
* **deps:** update dependency claranet/linux-vm/azurerm to ~> 8.5.0 87d6986
* **deps:** update dependency opentofu to v1.10.0 742f184
* **deps:** update dependency opentofu to v1.10.1 863c569
* **deps:** update dependency opentofu to v1.10.3 8d385a4
* **deps:** update dependency opentofu to v1.10.6 df802a2
* **deps:** update dependency tflint to v0.58.1 b6a3bec
* **deps:** update dependency tflint to v0.59.1 55eab4b
* **deps:** update dependency trivy to v0.66.0 a7b348f
* **deps:** update dependency trivy to v0.67.0 625e682
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v6 afad8eb
* **deps:** update terraform claranet/nsg/azurerm to ~> 8.1.0 5aefebd
* **deps:** update terraform claranet/subnet/azurerm to ~> 8.1.0 ac94539
* **deps:** update tools 3a3995c
* **deps:** update tools d718d72
* **deps:** update tools 6832fec

## 8.2.3 (2025-06-11)

### Bug Fixes

* **deps:** 🔧 update `azurerm` provider version to `~> 4.26` aea1360

### Miscellaneous Chores

* **deps:** update dependency claranet/linux-vm/azurerm to ~> 8.4.0 f7ab066
* **deps:** update dependency trivy to v0.63.0 8295896
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.1 875464d

## 8.2.2 (2025-05-26)

### Bug Fixes

* **deps:** 🔧 update provider versions to 4.11 and module versions to 8.0.2 895235f

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.9.1 435f2ab
* **deps:** update dependency tflint to v0.57.0 57924c0
* **deps:** update dependency tflint to v0.58.0 8969630
* **deps:** update dependency trivy to v0.62.0 a62691f
* **deps:** update dependency trivy to v0.62.1 a5a2554

## 8.2.1 (2025-04-22)

### Bug Fixes

* **AZ-1548:** add zone_id variable f030dcb

### Miscellaneous Chores

* **deps:** update dependency pre-commit to v4.2.0 dd40db2
* **deps:** update dependency terraform-docs to v0.20.0 046dee3
* **deps:** update dependency trivy to v0.61.1 96a5dda
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.0 2dbd894
* **deps:** update terraform claranet/linux-vm/azurerm to ~> 8.3.0 848eb3f
* **deps:** update tools 01546cf

## 8.2.0 (2025-03-14)

### Features

* add module vm v8.2 variables 6289a49

### Miscellaneous Chores

* **deps:** update dependency claranet/linux-vm/azurerm to ~> 8.2.0 3e9a051
* **deps:** update dependency claranet/regions/azurerm to v8 5972d0a
* **deps:** update dependency trivy to v0.60.0 0e5024a
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.22.0 d1861f7
* **deps:** update terraform claranet/regions/azurerm to ~> 7.4.0 179145c

## 8.1.0 (2025-02-24)

### Features

* **AZ-1518:** add security boot option 704eb78

### Miscellaneous Chores

* **deps:** update terraform claranet/linux-vm/azurerm to ~> 8.1.0 dcc118b

## 8.0.3 (2025-02-18)

### Bug Fixes

* bump `regions` module 8ca46b4

### Miscellaneous Chores

* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.21.0 27ed9df
* **deps:** update terraform claranet/claranet-gallery-images/azapi to ~> 8.1.0 68a5c8f

## 8.0.2 (2025-02-07)

### Bug Fixes

* **AZ-1514:** fixed default maintenance mode 0357450

### Miscellaneous Chores

* **deps:** update dependency pre-commit to v4.1.0 aa113d8
* **deps:** update dependency tflint to v0.55.1 877b5fd
* **deps:** update dependency trivy to v0.58.2 c52c365
* **deps:** update dependency trivy to v0.59.0 91902c1
* **deps:** update dependency trivy to v0.59.1 70ed32a
* **deps:** update terraform claranet/regions/azurerm to ~> 7.3.0 1267a26
* update Github templates 9fff6c1
* update tflint config for v0.55.0 5814a68

## 8.0.1 (2025-01-13)

### Bug Fixes

* **AZ-1088:** add `moved` block e298b99

### Miscellaneous Chores

* **deps:** update dependency tflint to v0.55.0 676e579

## 8.0.0 (2025-01-10)

### ⚠ BREAKING CHANGES

* **AZ-1088:** AzureRM Provider v4+ and OpenTofu 1.8+

### Features

* **AZ-1088:** add `bastion_public_ip_enabled` variable bbd5e6a
* **AZ-1088:** add `vtpm_enabled` variable 3f54f69
* **AZ-1088:** module v8 structure and updates 417fa70
* **AZ-1088:** optional subnet creation 5cfd395
* **AZ-1088:** remove `bastion_public_ip_sku` variable cf89e01

### Code Refactoring

* **AZ-1088:** apply suggestions improvements 23be73a
* **AZ-1088:** apply variable naming suggestions 1b79c2c

### Miscellaneous Chores

* **AZ-1088:** update variables for module `linux-vm` v8 98d912e
* **deps:** update dependency claranet/nsg/azurerm to v8 dede002
* **deps:** update dependency claranet/subnet/azurerm to v8 bf4bafd
* **deps:** update dependency opentofu to v1.8.7 1cd2b7f
* **deps:** update dependency opentofu to v1.8.8 a06669c
* **deps:** update dependency opentofu to v1.9.0 1a014e7
* **deps:** update dependency trivy to v0.58.1 89cd266
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 2b44482
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 cd3645b
* **deps:** update terraform claranet/claranet-gallery-images/azapi to v8 171462e
* **deps:** update terraform claranet/linux-vm/azurerm to ~> 7.13.0 0a410c5
* **deps:** update tools 8f78f9b
* **trivy:** add ignore file f81aeff

## 7.9.0 (2024-10-18)

### Features

* **AZ-1476:** add subnet variable c236450

### Documentation

* **AZ-1476:** change variable description 29417fb

### Miscellaneous Chores

* **deps:** update dependency claranet/linux-vm/azurerm to ~> 7.12.0 8024390
* **deps:** update dependency claranet/nsg/azurerm to ~> 7.8.0 35248d9
* **deps:** update dependency claranet/subnet/azurerm to ~> 7.2.0 d5d9f3c
* **deps:** update dependency opentofu to v1.8.3 aacdd43
* **deps:** update dependency pre-commit to v4 b149d7d
* **deps:** update dependency pre-commit to v4.0.1 836e32b
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 4ea2516
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 e09c8ea
* prepare for new examples structure 4da2904
* update examples structure 1aa9162

## 7.8.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider 932f25b

### Documentation

* update README with `terraform-docs` v0.19.0 dab67ac

## 7.7.1 (2024-09-27)

### Documentation

* update README badge to use OpenTofu registry dedbc59

### Miscellaneous Chores

* **deps:** update dependency claranet/subnet/azurerm to ~> 7.1.0 a2a50bb
* **deps:** update dependency opentofu to v1.8.2 8450517
* **deps:** update dependency terraform-docs to v0.19.0 1598313
* **deps:** update dependency trivy to v0.55.0 577a054
* **deps:** update dependency trivy to v0.55.1 3834db5
* **deps:** update dependency trivy to v0.55.2 58b6b33
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 da883b5
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 f7bcb72
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 8d06c10
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 257aa54
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 06a0fd6
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 712b2af
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 01f4b2c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 f5b569c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 ceba937
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 4277a74
* **deps:** update terraform claranet/regions/azurerm to ~> 7.2.0 450b680
* **deps:** update tools ddeed8f

## 7.7.0 (2024-08-09)


### Features

* add `bastion_nic_accelerated_networking_enabled parameter` 38d3076


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.3 c159ded
* **deps:** update dependency opentofu to v1.8.1 16fb33d
* **deps:** update dependency pre-commit to v3.8.0 91a9e5f
* **deps:** update dependency tflint to v0.52.0 7bd7b4e
* **deps:** update dependency trivy to v0.53.0 646c794
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 d758d7e
* **deps:** update tools 79936c2

## 7.6.2 (2024-07-01)


### Bug Fixes

* **deps:** upgrade `linux-vm` to latest version a0d9509


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.1 db023ed
* **deps:** update dependency opentofu to v1.7.2 2c5e239
* **deps:** update dependency pre-commit to v3.7.1 07f37fb
* **deps:** update dependency terraform-docs to v0.18.0 35aaba6
* **deps:** update dependency tflint to v0.51.0 a366dc6
* **deps:** update dependency tflint to v0.51.1 03e4b97
* **deps:** update dependency tflint to v0.51.2 26fa5c4
* **deps:** update dependency trivy to v0.50.4 845786d
* **deps:** update dependency trivy to v0.51.0 24960a3
* **deps:** update dependency trivy to v0.51.1 4d35925
* **deps:** update dependency trivy to v0.51.2 3f5ff19
* **deps:** update dependency trivy to v0.51.4 b5cc416
* **deps:** update dependency trivy to v0.52.0 d9ad758
* **deps:** update dependency trivy to v0.52.1 5b974b8
* **deps:** update dependency trivy to v0.52.2 ba1aebc
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 8bfbe41
* **deps:** update terraform claranet/subnet/azurerm to v7 b69690b

## 7.6.1 (2024-04-30)


### Styles

* **output:** remove unused version from outputs-module ddc97e3


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 6f2ca19
* **AZ-1391:** update semantic-release config [skip ci] 794f671


### Miscellaneous Chores

* **deps:** add renovate.json 7668203
* **deps:** enable automerge on renovate 50b6378
* **deps:** update dependency opentofu to v1.7.0 67eeb48
* **deps:** update dependency trivy to v0.50.2 6a69beb
* **deps:** update renovate.json 23d97e5
* **deps:** update terraform claranet/linux-vm/azurerm to ~> 7.11.0 4b8f360
* **deps:** update terraform claranet/nsg/azurerm to ~> 7.6.0 799abca
* **deps:** update terraform claranet/nsg/azurerm to ~> 7.7.0 874d335
* **deps:** update terraform claranet/regions/azurerm to v7 400d7c4
* **deps:** update terraform claranet/subnet/azurerm to ~> 6.3.0 32abf7c
* **pre-commit:** update commitlint hook 3c7b45c
* **release:** remove legacy `VERSION` file 77417c5

# v7.6.0 - 2024-01-19

Breaking
  * AZ-1207: Rework module
  * AZ-1207: Use directly linux-vm module
  * AZ-1207: Use Claranet golden image by default
  * AZ-1207: Rework variables

# v7.5.0 - 2023-07-21

Added
  * AZ-1115: Add `admin_password` parameter (used by Claranet OneBastion)

# v7.4.0 - 2023-06-16

Changed
  * AZ-1080: Bump `bastion-vm` module to add `bypassPlatformSafetyChecksOnUserSchedule` when `patch_mode` is `AutomaticByPlatform`.

# v7.3.0 - 2023-04-28

Added
  * AZ-1064: Add `custom_facing_ip_address` parameter to `bastion-vm` module

# v7.2.0 - 2023-03-22

Changed
  * AZ-1019: Bump `bastion-vm` module

# v7.1.1 - 2022-12-23

Fix
  * AZ-962: Fix wrong offer in default bastion vm variable

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
