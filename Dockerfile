# Stole the required bits from https://github.com/dpetersen/dev-container-base/blob/master/Dockerfile 
FROM ubuntu:18.04

# Start by changing the apt output, as stolen from Discourse's Dockerfiles.
RUN echo "debconf debconf/frontend select Teletype" | debconf-set-selections &&\
# Probably a good idea
    apt-get update &&\
# Nobody is happy when these aren't up-to-date
    apt-get install -y ca-certificates &&\
# Basic dev tools
    apt-get install -y openssh-client git unzip  build-essential wget ctags man curl direnv software-properties-common &&\
# Set up SSH. We set up SSH forwarding so that transactions like git pushes
# from the container happen magically.
    apt-get install -y openssh-server &&\
    mkdir /var/run/sshd &&\
    echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config &&\
# Install Terraform
    wget https://releases.hashicorp.com/terraform/1.0.1/terraform_1.0.1_linux_amd64.zip &&\
    unzip terraform_1.0.1_linux_amd64.zip &&\
    mv terraform /usr/bin &&\
    chmod +x /usr/bin/terraform

LABEL org.opencontainers.image.source https://github.com/iaingblack/DeploymentPipeline