# Illumio Terraform Example

## Description
Example of creating labels and unmanaged workloads from JSON files using Terraform.

## Input Files
See `input_files` directory for two JSON files that define labels and unmanaged workloads.

## Terraform Version
Testing completed on Terraform 1.4.6

## Example Command
```
terraform init
terraform apply -var "illumio_api_user=api_1a...3" -var "illumio_api_secret=0f...4c" -var "illumio_org_id=1" -var "illumio_pce_host=https://pitta-lab.poc.segmentationpov.com:8443"
```
