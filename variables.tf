# NTTDATA - DIGITAL ARCHITECTURE - ENGENIEER
# Create: Marcos Cianci - mlopesci@emeal.nttdata.com
# Date: Seg 28 Mar 2022
# PROJECT AWS FAULT INJECTION SERVICES


### GLOBALS ###
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "environments" {

    description = ""
    type        = string
}



### AWS FIS - Templates ###
variable "experiment_template" {

  type = map(object({

      template_name       = string
      template_source     = string
      region              = string
      ec2_arn             = string
      duration            = string
      DurationSeconds     = number
      Delay               = number
      description         = string
      interface           = string
  }))
}

### TAGS ###
variable "tags" { }