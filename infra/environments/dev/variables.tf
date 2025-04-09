
# You can add variables here if you need to parameterize the configuration
variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
  default     = [""]  # TODO: Provide subnet IDs if not using 'locals'
}
