{
    "description": "template_CpuStress",
    
    "targets": {
        "Instances-Target-1": {
            "resourceType": "aws:ec2:instance",
            "resourceArns": [
                "arn:aws:ec2:us-east-1:385007816573:instance/i-0d6e0db97f5edee11"
            ],
            "selectionMode": "ALL"
        }
    },
    "actions": {
        "CpuStress": {
            "actionId": "aws:ssm:send-command",
            "parameters": {
                "documentArn": "arn:aws:ssm:us-east-1::document/AWSFIS-Run-Network-Latency",
                "documentParameters": "{}",
                "duration": "PT5M"
            },
            "targets": {
                "Instances": "Instances-Target-1"
            }
        }
    },
    "stopConditions": [
        {
            "source": "none"
        }
    ],
    "roleArn": "arn:aws:iam::385007816573:role/role-fis-si2",
    "tags": {
        "Name": "teste"
    }
}