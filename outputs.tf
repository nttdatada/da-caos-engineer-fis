# NTTDATA - DIGITAL ARCHITECTURE - ENGENIEER
# Create: Marcos Cianci - mlopesci@emeal.nttdata.com
# Date: Seg 28 Mar 2022
# PROJECT AWS FAULT INJECTION SERVICES

### AWS IAM ###
output "role_id" {
  
  description = ""
  value       = module.role_fis.role-id
}

output "role_arn" {
  
  description = ""
  value       = module.role_fis.role-arn
}

output "role_id_ec2" {
  
  description = ""
  value       = module.role_ec2.role-id
}

output "role_arn_ec2" {
  
  description = ""
  value       = module.role_ec2.role-arn
}

output "instance_profile_name" {

  description = ""
  value = module.instance_profile_ec2.instance_profile_name
}



### AWS SECURITY GROUP ###
output "security_group_id_elb" {

  description = ""
  value = module.sg_elb.security_group_id
}

output "security_group_id_ec2" {

  description = ""
  value = module.sg_ec2.security_group_id
}

