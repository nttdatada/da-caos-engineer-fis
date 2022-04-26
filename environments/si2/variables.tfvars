# NTTDATA - DIGITAL ARCHITECTURE - ENGENIEER
# Create: Marcos Cianci - mlopesci@emeal.nttdata.com
# Date: Seg 28 Mar 2022
# PROJECT AWS FAULT INJECTION SERVICES

### GLOBALS ###
aws_region = "us-east-1"
environments = "stage"

### AWS FIS - Templates ###
experiment_template = {

    "ec2-network-latency" = {

        template_name       = "gameday-ec2-networklatency-si2"
        template_source     = "templates/fis/ec2-network-latency.tpl"
        region              = "us-east-1"
        ec2_arn             = "arn:aws:ec2:us-east-1:385007816573:instance/i-0d6e0db97f5edee11"
        duration            = "PT5M"
        DurationSeconds     = 300
        Delay               = 100
        description         = "GameDay S12 EC2 NetworkLatency"
        interface           = ""
    },
    "ec2-network-loss" = {

        template_name       = "gameday-ec2-networkloss-si2"
        template_source     = "templates/fis/ec2-network-loss.tpl"
        region              = "us-east-1"
        ec2_arn             = "Caos Engineer-AWS FIS-autoscaled"
        duration            = "PT3M"
        DurationSeconds     = 300
        Delay               = 30
        description         = "GameDay S12 EC2 NetworkLoss"
        interface           = "ens5"
    },
    "asg-network-latency" = {

        template_name       = "gameday-asg-networklatency-si2"
        template_source     = "templates/fis/asg-network-latency.tpl"
        region              = "us-east-1"
        ec2_arn             = "Caos Engineer-AWS FIS-autoscaled"
        duration            = "PT3M"
        DurationSeconds     = 300
        Delay               = 800
        description         = "GameDay S12 ASG NetworkLoss"
        interface           = "ens5"
    }
}


### TAGS ##
tags = {
    Environment     = "SI2"
    Terraform       = true
    Organizarion    = "NTTDATA"
    Departament     = "DA"
    Area           = "Engineer"
    Project         = "Caos Engineer GameDay"
}


