# KREAM cloud formation template

The kream_template.json file is a cloud formation template to provision the KREAM environment in AWS.

## Usage:

This template should not be edited unless the user has a thorough understanding of Kubernetes and the puppet modules used in this repo.

It will create the following AWS Resource types, so ensure the IAM role you are using has the appropriate permissions to work with the following.

* AWS::EC2::Instance
* AWS::EC2::InternetGateway
* AWS::EC2::Route
* AWS::EC2::RouteTable
* AWS::EC2::SecurityGroup
* AWS::EC2::Subnet
* AWS::EC2::SubnetRouteTableAssociation
* AWS::EC2::VPC
* AWS::Route53::HostedZone
* AWS::Route53::RecordSet

The Kubernetes cluster is installed and managed using the latest available version of Puppet Enterprise, configured to use Puppet Code Manager.

The template has a region map for the Ubuntu 16.04 AMI used in this repo so resources can be provisioned in any AWS region.

To use this template the user needs to provide a stack name and an existing key pair name. This can be done via the AWS console or by running the following command:

`aws cloudformation create-stack --stack-name kream --template-body file://kream_template.json --parameters ParameterKey=KeyPairName,ParameterValue=kream`


