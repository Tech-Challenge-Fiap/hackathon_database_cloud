variable "DB_PASSWORD" {
  type = string
}

variable "DB_USER" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-051dad9c12510933f"
}


variable "subnets_ids" {
  default = ["subnet-0eb1799a31f289bb2", "subnet-070da0a3ddce96f64"]
}