{
    "description": "${description}",

    "targets": {
        "Instances-Target-1": {
            "resourceType": "aws:ec2:instance",
            "resourceTags": {
                "Name": "${ec2_arn}"
            },
            "filters": [
                {
                    "path": "State.Name",
                    "values": [
                        "running"
                    ]
                }
            ],
            "selectionMode": "COUNT(1)"
        }
    },
    "actions": {
        "networkloss": {
            "actionId": "aws:ssm:send-command",
            "parameters": {
                "documentArn": "arn:aws:ssm:us-east-1::document/AWSFIS-Run-Network-Packet-Loss",
                "documentParameters": "{\"LossPercent\":\"${Delay}\", \"Interface\":\"${interface}\", \"DurationSeconds\":\"${DurationSeconds}\", \"InstallDependencies\":\"True\"}",
                "duration": "${duration}"
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
    "roleArn": "${role}",
    "tags": {
        "Name": "${template_name}"
    }
}