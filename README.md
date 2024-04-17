# Generating IaC from Existing Cloud Resources

This webinar will focus on OpenTofu, but works with Terraform as well. Simply replace `tofu` with `terraform`.

## IaC Generation Tour

## Using Terraformer

To make this webinar easy to follow along and clean up after, we will create infrastructure using a Terraform module and then use the created resources to generate code using Terraformer.

### Setup

```shell
cd src
tofo init
```

You are going to need to set a _VPC ID_ and a set of _Subnet IDs_ to run this terraform module.

```shell
export AWS_REGION=us-west-2
```

*List VPCs*:
```shell
aws ec2 describe-vpcs --region ${AWS_REGION}
```

*Find the VPC you want to use and set the ID*:

```shell
export VPC_ID=my-id
```

*Pick a set of Subnet IDs*:

```shell
aws ec2 describe-subnets --region ${AWS_REGION} --filters "Name=vpc-id,Values=${VPC_ID}" --query "Subnets[*].SubnetId" --output json
```

Finally, uncomment "networking" in [./src/example.auto.tfvars] and set your vpc_id and subnet_ids.

```shell
tofu apply
```

Once this completes, there will be a `terraform.tfstate` file with all of your managed resources. Lets grab the IDs/ARNs for use in Terraformer.

```shell
jq '[.resources | map(select(.mode == "managed")) | .[] | {type: .type} + (.instances[] | {arn: .attributes.arn, id: .attributes.id})]' terraform.tfstate > resources.json
```

### Generating IaC

#### Everything

Putting everything in one OpenTofu / Terraform module is going to be a **Bad Time**™️, but lets see what the output looks like.

**NOTE:** This can take hours.

```shell
cd generated/everything
echo "provider \"aws\" {}" > providers.tf
terraform init
terraformer import aws --resources=* --regions=us-west-2
tofu init
tofu plan
```

**Use Case:** Extremely minimal cloud presence and/or for SaaS products that want to offer a 'run in your cloud' setup module.

#### By Service

#### By ID

#### By Tags

### Refactoring Terraformer Code

#### Prompts

#####  
