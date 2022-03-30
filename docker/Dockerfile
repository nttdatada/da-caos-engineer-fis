FROM debian:buster-slim

ENV PYTHONIOENCODING UTF-8
ENV TERRAFORM_VERSION 0.14.6
ENV KUBECTL_VERSION 1.18.0
ENV AWS_IAM_AUTHENTICATOR_VERSION 1.15.10
ENV HELM_VERSION=3.2.0
ENV HELM_SSM_PLUGIN=2.0.3

RUN apt-get -y -qq update && \
        apt-get install -y -qq curl unzip make wget vim watch packer ansible python

WORKDIR /app/

RUN curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.15/bin/linux/amd64/kubectl && \
     chmod +x ./kubectl && \
     mv ./kubectl /usr/local/bin/kubectl

RUN  curl --silent https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip

RUN  unzip terraform.zip && \
         mv terraform /usr/local/bin/ && \
         rm terraform.zip

RUN  curl --silent https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz --output helm-linux-amd64.tar.gz

RUN  tar xvf helm-linux-amd64.tar.gz && \
         mv linux-amd64/helm /usr/local/bin/helm && \
         chmod +x /usr/local/bin/helm && \
         rm helm-linux-amd64.tar.gz && \
         rm -rf linux-amd64

RUN  helm plugin install https://github.com/codacy/helm-ssm/releases/download/$HELM_SSM_PLUGIN/helm-ssm-linux.tgz
# https://docs.aws.amazon.com/pt_br/eks/latest/userguide/install-aws-iam-authenticator.html

RUN  curl --silent https://amazon-eks.s3.us-west-2.amazonaws.com/$AWS_IAM_AUTHENTICATOR_VERSION/2020-02-22/bin/linux/amd64/aws-iam-authenticator --output /usr/local/bin/aws-iam-authenticator && \
         chmod +x /usr/local/bin/aws-iam-authenticator

RUN  curl --silent https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip --output awscliv2.zip

RUN  unzip awscliv2.zip  > /dev/null && \
         /bin/bash aws/install && \
         rm awscliv2.zip

RUN  curl --silent https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz --output helm-linux-amd64.tar.gz

RUN  tar -xzvf helm-linux-amd64.tar.gz && \
         mv linux-amd64/helm /usr/local/bin/helm && \
         chmod +x /usr/local/bin/helm && \
         rm helm-linux-amd64.tar.gz && \
         rm -rf linux-amd64

RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
     mv /tmp/eksctl /usr/local/bin && \
     chmod +x /usr/local/bin/eksctl

RUN useradd -ms /bin/bash appuser

#ADD .bashrc /home/appuser/.bashrc

#RUN mkdir /home/appuser/.kube

#COPY kubeconfig/.kube /home/appuser/.kube

#RUN chown -R appuser:appuser /home/appuser/.kube

USER appuser

RUN mkdir ~/.aws/ && cd ~/.aws && touch config && touch credentials

RUN export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials && export AWS_PROFILE=da-engineer && export AWS_REGION=us-east-1