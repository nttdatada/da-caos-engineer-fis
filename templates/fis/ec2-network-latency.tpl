{
    "description": "${description}",

    "targets": {
        "ec2-instances": {
            "resourceType": "aws:ec2:instance",
            "resourceArns": [
                "${ec2_arn}"
            ],
            "selectionMode": "ALL"
        }
    },

    "actions": {
        "NetworkLatency": {
            "actionId": "aws:ssm:send-command",
            "description": "run network latency using ssm",
            "parameters": {
                "duration": "${duration}",
                "documentArn": "arn:aws:ssm:${region}::document/AWSFIS-Run-Network-Latency",
                "documentParameters": "{\"DurationSeconds\": \"${DurationSeconds}\", \"InstallDependencies\": \"True\", \"DelayMilliseconds\": \"${Delay}\"}"
            },
            "targets": {
                "Instances": "ec2-instances"
            }
        }
    },

    "stopConditions":[
        {
            "source": "none"
        }
    ],

    "roleArn": "${role}",

    "tags": {
        "Name":"${template_name}"
    }
}