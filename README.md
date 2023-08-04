# openstack-create-domain

OpenStack Domains are high-level containers for projects, users and groups. They can be used to centrally manage all keystone-based identity components. It can be thought of as an equivalent to AWS Organizations in function.

This Terraform config will create:

1. Domain and projects
2. Networks, subnets, and routers
3. Bastion host

# Pre-requisites

# Terraform
Install Terraform:
```shell
wget https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_linux_amd64.zip
unzip terraform_1.3.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform
```

# Getting started
1. Create a branch from master repo e.g. `domain/<TENANT_NAME>`
2. Set the required variables in `variables.tf`:
- `domain_name` - Name of the tenant
- `project_name` - This can be the same value as `domain_name` if there are no other subprojects
- `os_environment` - Set this to `dev` or `prod`
- `os_username` - Your OpenStack username
3. set the `admin_subnet_cidr` variable. 
   - Be sure to check which subnets are already in-use in order to avoid IP conflicts: 
   - `openstack subnet list | grep xxx | awk '{ print $8 }' | sort`
   - Set the variable to the next `xxx.xxx.x.0/24` subnet not already in use.

# Usage
1. Load your OpenStack ENVs from your admin openrc `source openrc.sh`
2. Run `terraform init` to initialize Terraform
3. Run `terraform plan` 
4. Finally, run `terraform apply` to apply the Terraform stack.

# Deleting resources
`terraform destroy`
