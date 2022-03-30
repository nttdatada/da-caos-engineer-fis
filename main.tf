# NTTDATA - DIGITAL ARCHITECTURE - ENGENIEER
# Create: Marcos Cianci - mlopesci@emeal.nttdata.com
# Date: Seg 28 Mar 2022
# PROJECT AWS FAULT INJECTION SERVICES

### AWS IAM ###
# AWS FIS #
module "role_fis" {

    source          = "git::https://github.com/nttdatada/terraform-aws-iam.git//roles?ref=v1.1"

    role_name       = "role-fis-${terraform.workspace}"
    role_json       = file("templates/iam/role_fis.json")
}

module "policy_fis_ssm" {

    source = "git::https://github.com/nttdatada/terraform-aws-iam.git//policy?ref=v1.1"

    policy_name = "policy-fis-ssm-${terraform.workspace}"
    policy_json = file("templates/iam/policy_fis_ssm.json")

    policy_attachment_name = "policy-attach-fis-ssm-${terraform.workspace}"
    roles_id = [module.role_fis.role-id]
}

module "policy_fis_ec2" {

    source = "git::https://github.com/nttdatada/terraform-aws-iam.git//policy?ref=v1.1"

    policy_name = "policy-fis-ec2-${terraform.workspace}"
    policy_json = file("templates/iam/policy_fis_ec2.json")

    policy_attachment_name = "policy-attach-fis-ec2-${terraform.workspace}"
    roles_id = [module.role_fis.role-id]
}

module "policy_fis_cloudwath" {

    source = "git::https://github.com/nttdatada/terraform-aws-iam.git//policy?ref=v1.1"

    policy_name = "policy-fis-cloudwatch-${terraform.workspace}"
    policy_json = file("templates/iam/policy_fis_cloudwatch.json")

    policy_attachment_name = "policy-attach-fis-cloudwatch-${terraform.workspace}"
    roles_id = [module.role_fis.role-id]
}


# AWS EC2 #
module "role_ec2" {

    source          = "git::https://github.com/nttdatada/terraform-aws-iam.git//roles?ref=v1.1"

    role_name       = "role-ec2-${terraform.workspace}"
    role_json       = file("templates/iam/role_ec2.json")
}

module "policy_ec2" {

    source = "git::https://github.com/nttdatada/terraform-aws-iam.git//policy?ref=v1.1"

    policy_name = "policy-ec2-${terraform.workspace}"
    policy_json = file("templates/iam/policy_ec2.json")

    policy_attachment_name = "policy-attach-ec2-${terraform.workspace}"
    roles_id = [module.role_ec2.role-id]
}

module "instance_profile_ec2" {

    source = "git::https://github.com/nttdatada/terraform-aws-iam.git//iam_instance_profile?ref=v1.0"

    name_instance_profile = "instance-profile-ec2-${terraform.workspace}"
    role_id               = module.role_ec2.role-id 

}

### AWS ELB ###
module "elb" {

  source                      = "git::https://github.com/nttdatada/terraform-aws-elb.git"

  name_elb                    = "lb-fis-${terraform.workspace}"
  subnets                     = [ data.aws_subnet.subnet-c.id , data.aws_subnet.subnet-d.id ]
  security_groups             = [ module.sg_elb.security_group_id ]
  internal                    = false

  cross_zone_load_balancing   = true
  idle_timeout                = 50
  connection_draining         = true
  connection_draining_timeout = 60

  instance_port               = 8080
  instance_protocol           = "http"
  lb_port                     = 80
  lb_protocol                 = "http"
  ssl_certificate_id          = ""

  interval                    = 60
  healthy_threshold           = 10
  unhealthy_threshold         = 10
  timeout                     = 30
  target                      = "HTTP:8080/"

  tags                        = var.tags
}

### AWS ASG ###
module "asg_ec2_fis" {    
  
    source                      = "git::https://github.com/nttdatada/terraform-aws-asg.git"    
    
    # AutoScaling
    asg_name                    = "asg-ec2-fis-${terraform.workspace}"
    asg_max_size                = "0"
    asg_min_size                = "0"
    health_check_grace_period   = "60"
    health_check_type           = "ELB"
   
    load_balancers              =  module.elb.elb_id 
    subnets_zones               = [ data.aws_subnet.subnet-c.id , data.aws_subnet.subnet-d.id ]     
    
    # AutoScaling Policy    
    policy_type                 = "StepScaling"
    adjustment_type             = "ChangeInCapacity"
    scale_in_cooldown           = "60"
    metric_aggregation_type     = "Average"
    estimated_instance_warmup   = 240
    scale_out_adjustment_0      = "1"
    scale_out_adjustment_1      = "2"
    scale_out_adjustment_2      = "3"    
    
    # Lifecycle Hook    
    lchook_name                 = "InstanceWarmUpHook"
    default_result              = "CONTINUE"
    heartbeat_timeout           = 180
    lifecycle_transition        = "autoscaling:EC2_INSTANCE_LAUNCHING"   
    
    # Launch Configuration   
    ami                          = "ami-0563e71b908da045f"
    iam_instance_profile         = module.instance_profile_ec2.instance_profile_name
    instance_type                = "t3.micro"
    disk_size                    = "30"
    security_groups              = [ module.sg_ec2.security_group_id ]
    stack                        = "AWS FIS"
    alias                        = "DA"
    deploy_bucket                = ""
    environments                 = var.environments
    project                      = "Caos Engineer"
    template                     = data.template_file.userdata_ec2_fis.rendered
    key_name                     = aws_key_pair.key.key_name
  
}

resource "aws_key_pair" "key" {

  key_name   = "ec2-fis-${terraform.workspace}"
  public_key = tls_private_key.tls.public_key_openssh  
  
  tags = {
    Name    = "ec2-fis-${terraform.workspace}"
    Env     = terraform.workspace
  } 
}

resource "tls_private_key" "tls" {
  algorithm = "RSA"
}

resource "local_file" "key" {
  
  content  = tls_private_key.tls.private_key_pem
  filename = "ec2-fis-${terraform.workspace}.pem"  
  
  provisioner "local-exec" {
    command = "chmod 600 ec2-fis-${terraform.workspace}.pem"
  }
}



### AWS SECURITY GROUP ###
## AWS ELB ###
module "sg_elb" {

  source  = "git::https://github.com/nttdatada/terraform-aws-securitygroup.git"

  name_sg       = "scg-elb-fis-${terraform.workspace}"
  vpc_id        = data.aws_vpc.vpc.id
  environments  = terraform.workspace

  tags          = var.tags

   sg_rules = [

        {
            type = "egress"
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = "0.0.0.0/0"
            description = "Allow Trafic Outbound"
        },
        {
            type = "ingress"
            from_port = 80
            to_port = 80
            protocol = "TCP"
            cidr_blocks = "0.0.0.0/0"
            description = "Allow HTTP Trafic Inbound"
        },
    ]

}

module "sg_ec2" {

  source  = "git::https://github.com/nttdatada/terraform-aws-securitygroup.git"

  name_sg       = "scg-ec2-fis-${terraform.workspace}"
  vpc_id        = data.aws_vpc.vpc.id
  environments  = terraform.workspace

  tags          = var.tags

   sg_rules = [

        {
            type = "egress"
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = "0.0.0.0/0"
            description = "Allow Trafic Outbound"
        },
        {
            type = "ingress"
            from_port = 22
            to_port = 22
            protocol = "TCP"
            cidr_blocks = "0.0.0.0/0"
            description = "Allow SSH"
        },
        {
            type = "ingress"
            from_port = 8080
            to_port = 8080
            protocol = "TCP"
            cidr_blocks = "0.0.0.0/0"
            description = "Allow HTTP Trafic Inbound"
        },
    ]
}


### AWS FIS - Templates - LocalFiles ###
resource "local_file" "fis-template" {

  for_each = var.experiment_template

  content = templatefile( each.value.template_source, {

            region              = each.value["region"]
            ec2_arn             = each.value["ec2_arn"] 
            duration            = each.value["duration"]
            DurationSeconds     = each.value["DurationSeconds"]
            Delay               = each.value["Delay"]
            description         = each.value["description"]
            template_name       = each.value["template_name"]
            role                = module.role_fis.role-arn

  })
 
  filename        = "${each.value["template_name"]}.json"
  file_permission = "0600"
}


### Create Template ###
resource "local_file" "create-templates" {

  for_each = var.experiment_template

  content = join("\n", [
    "#!/bin/bash -ex",
    "OUTPUT='.fis_cli_result'",
    "TEMPLATES=('${each.value.template_name}.json')",
    "for template in $${TEMPLATES[@]}; do",
    "  aws fis create-experiment-template --cli-input-json file://$${template} --output text --query 'experimentTemplate.id' 2>&1 | tee -a $${OUTPUT}",
    "done",
    ]
  )

  filename        = "fis-create-experiment-templates.sh"
  file_permission = "0600"
}


resource "null_resource" "create-templates" {

  for_each = var.experiment_template

  depends_on = [
    local_file.fis-template,
  ]

  provisioner "local-exec" {
    when    = create
    command = "bash fis-create-experiment-templates.sh"
  }
}

### Delete template ###

resource "local_file" "delete-templates" {

  for_each = var.experiment_template

  content = join("\n", [
    "#!/bin/bash -ex",
    "OUTPUT='.fis_cli_result'",
    "while read id; do",
    "  aws fis delete-experiment-template --id $${id} --output text --query 'experimentTemplate.id' 2>&1 > /dev/null",
    "done < $${OUTPUT}",
    "rm $${OUTPUT}",
    ]
  )
  filename        = "fis-delete-experiment-templates.sh"
  file_permission = "0600"
}

resource "null_resource" "delete-templates" {

  for_each = var.experiment_template

  depends_on = [
    local_file.fis-template,
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "bash fis-delete-experiment-templates.sh"
  }
}