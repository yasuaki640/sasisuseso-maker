variable "name" {
      description = "Name of the security group"
      type        = string
    }

    variable "description" {
      description = "Description of the security group"
      type        = string
      default     = "Managed by Terraform"
    }

    variable "vpc_id" {
      description = "ID of the VPC where the security group will be created"
      type        = string
    }

    variable "tags" {
      description = "A map of tags to assign to the security group"
      type        = map(string)
      default     = {}
    }

    variable "ingress_with_cidr_blocks" {
      description = "List of ingress rules with CIDR blocks"
      type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        description = string
        cidr_blocks = list(string)
      }))
      default = []
    }

    variable "ingress_with_source_security_group_id" {
      description = "List of ingress rules with source security group ID"
      type = list(object({
        from_port                = number
        to_port                  = number
        protocol                 = string
        description              = string
        source_security_group_id = string
      }))
      default = []
    }

    variable "egress_with_cidr_blocks" {
      description = "List of egress rules with CIDR blocks"
      type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        description = string
        cidr_blocks = list(string)
      }))
      default = []
    }
