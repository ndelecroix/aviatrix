variable "account_name" { default = "aws-dev" }
variable "profile" { default = "dev-us-east-2" }
variable "region" { default = "us-east-2" }

### AWS = 1, GCP = 4, Azure = 8, OCI = 16.
variable "cloud_type" { default = 1 }

### VPC.
variable "vpc" {
  default = {
    name = "AWS-UE2-Dev1-VPC"
    cidr = "10.3.0.0/16"
  }
}

### IGW.
variable "igw" {
  default = {
    name = "AWS-UE2-Dev1-IGW"
  }
}

### Subnets.
variable "subnets" {
  default = {
    subnet1 = {
      name = "AWS-UE2-Dev1-Subnet1"
      az   = "us-east-2a"
      cidr = "10.3.0.0/24"
    },
    subnet2 = {
      name = "AWS-UE2-Dev1-Subnet2"
      az   = "us-east-2b"
      cidr = "10.3.1.0/24"
    }

  }
}

### Route tables.
variable "rt1" {
  default = {
    name = "AWS-UE2-Dev1-RT1"
  }
}
variable "rt2" {
  default = {
    name = "AWS-UE2-Dev1-RT2"
  }
}

### Spoke gateway.
variable "spoke_gateway" {
  default = {
    name         = "AWS-UE2-Dev1-Spoke-GW"
    size         = "t3.small"
    active_mesh  = true
    single_az_ha = true
    transit_gw   = "AWS-UE2-Transit-GW"
  }
}

### Routes to be inserted in the VPC route table with target = Spoke
### gateway ENI.
variable "routes" {
  default = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

