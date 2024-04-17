# Generating OpenTofu / Terraform from Existing Cloud Resources

This webinar will focus on OpenTofu, but the methods we discuss today will also work with Terraform. All you have to do is simply replace `tofu` with `terraform` in the code samples.

Watch a recording of the [Generating OpenTofu / Terraform from Existing Cloud Resources Webinar](https://www.massdriver.cloud/webinars/generating-infrastructure-as-code-from-existing-cloud-resources).

## Using Terraformer

For the purpose of this webinar, we're going to create infrastructure using a Terraform module. Then, we'll use the created resources to generate code using Terraformer. This will make it easier for you to follow along, and clean up afterward.

It's important to point out, however, that not all cloud resources are supported by Terraformer. For instance, you can check the current AWS supported resources [here](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md#supported-services) and of other clouds [here](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/).

### Setup

```shell
cd modules/aws-aurora-postgresql
tofo init
```

For this setup, you'll need to identify a _VPC ID_ and a set of _Subnet IDs_ to run this Terraform module and set an AWS_REGION.


```shell
export AWS_REGION=us-west-2
```

*List VPCs*:
```shell
aws ec2 describe-vpcs --region ${AWS_REGION}
```

Once you identify the VPC you wish to use, you can set its ID:

```shell
export VPC_ID=my-id
```

Now, you pick a set of Subnet IDs:

```shell
aws ec2 describe-subnets --region ${AWS_REGION} --filters "Name=vpc-id,Values=${VPC_ID}" --query "Subnets[*].SubnetId" --output json
```

Lastly, go to [modules/aws-aurora-postgresql/_example.auto.tfvars](modules/aws-aurora-postgresql/_example.auto.tfvars) and uncomment "networking". After that, set your vpc_id and subnet_ids, and then apply the modifications:

```shell
tofu apply
```

Once you complete the above steps, there will be a `terraform.tfstate` file with all of your managed resources. Let's grab the IDs/ARNs for use in Terraformer:

```shell
jq '[.resources | map(select(.mode == "managed")) | .[] | {type: .type} + (.instances[] | {arn: .attributes.arn, id: .attributes.id})]' terraform.tfstate > resources.json
```

### Generating IaC

Terraformer supports a number of ways to filter for cloud resources during generation, lets look at some pitfalls.

#### Everything

Note: Using the **Everything** approach can be extremely dangerous. Running this followed by a `terraform destroy` will wipe out your entire account.

This approach, though not highly recommended, is one of the first things you might find in the Terraformer docs. Consolidating everything into one OpenTofu / Terraform module is likely to give you a terrible experience due to complexity and possible errors.

Also, bear in mind that this approach could sometimes consume hours or even time out due to API limitations. Here is a description of the steps you'd take when using this approach:

```shell
cd generated/everything
echo "provider \"aws\" {}" > providers.tf

# Terraformer needs files in a certain place/.
terraform init

# A few of these resources throw panics, yay. Ignoring.
terraformer import aws --resources=* --regions=us-west-2 --excludes=identitystore

# Upgrade state, defaults to tf 0.13
terraform state replace-provider -auto-approve "registry.terraform.io/-/aws" "hashicorp/aws"

# Download the providers and modules for opentofu
tofu init

# Feel free to run this if you get here, it can take forever and time out on large accounts
tofu plan
```

**Use Case:** Extremely minimal cloud presence and/or for SaaS products that want to offer a 'run in your cloud' setup module.

#### By Resource Type

This approach will generate code for _every single resource_ in the cloud service. The blast radius on the state file can be pretty dangerous, and like the *everything* approach, can be **dangerous** if you accidentally run `tofu destroy`.

```shell
cd generated/by-resource-types
echo "provider \"aws\" {}" > provider.tf

# Terraformer needs files in a certain place/.
terraform init

# Setting the path pattern will flatten out the generation and put all of the terraform files in this directory. Generally resources are generated nested '{output:generated}/{provider}/{service}/{resource}.tf
terraformer import aws --resources=rds --regions=us-west-2 --path-pattern {output} -o .

# Upgrade state, defaults to tf 0.13
terraform state replace-provider -auto-approve "registry.terraform.io/-/aws" "hashicorp/aws"

# Download the providers and modules for opentofu
tofu init

# Lets check the plan!
tofu plan
```

Well, my generated code had about 30 errors :(

You'll also notice you probably got a lot more resources than you were expecting.

If we look at the number of resources this generated code for, I got 75...
```shell
grep resource *.tf | wc -l
```

Looking at the state file from the module that created the resources, you'll see there was only 5.

```shell
jq '[.resources | map(select(.mode == "managed")) | .[] | .type]' ../../modules/aws-aurora-postgresql/terraform.tfstate | grep aws | wc -l
```

**Use Case:** 

1. Small cloud presence where you have a few environments that you want to back out the configuration of say your staging/prod databases to workspaces. You'll need to do some heavy variable design, state surgery, and workspace creation.
2. Getting all of a cloud services config in once place to understand what you are running.
3. Managing all of a service from a central location. I'm not sure thats a 'best practice', but I'm positive some team works this way.

#### By ID

Very time consuming, you need to get a list of all of your ARN/IDs per module you want to generate code for.

Another problem with this approach is, terraformer's filtering is COMPLEX. You'll se below I have two values (joined by ':'), but it finds three resources. The filters are applied to all `--resources`. They can be configured to apply to only a particulary type using a type filter `--filter Type=rds;...`, but you'll also need to be familiar with the attributes of the terraform resource.

This means a lot of back-and-forth between the AWS console getting IDs, Cluster Identifiers, ARNs, etc, and the Terraform docs.

```shell
cd generated/by-id
echo "provider \"aws\" {}" > provider.tf

# Terraformer needs files in a certain place/.
terraform init

# Generate database IaC
terraformer import aws --resources=rds \
  --filter="Name=id;Value=webinar-test-opentofu:webinar-test-opentofu-20240416195347790500000002" \
  --regions=us-west-2 \
  --path-output . \
  --path-pattern "{output}"

# Upgrade state, defaults to tf 0.13
terraform state replace-provider -auto-approve "registry.terraform.io/-/aws" "hashicorp/aws"

tofu init
tofu plan
```

So this generated sort of what we were looking for. I could add additional filters to add my security groups and rules, but I'll leave that as an exercise for the reader.

I want to point out a few shortcomings with this approach.

1. You need to get identifiers / ARNs documented for all the resources you want to import. This can take a fair amount of time.
2. We built an Aurora RDS Cluster with `aws_rds_cluster_instance` instances, you can see that the terraform that was generated thinks its an RDS Instance `aws_db_instance`. This would be up to you to manually correct.
3. Some of the attribute values are conflicting. The original code created the resources using name prefixes, terraformer sets both, you'll need to delete the cluster_identifier, etc.

**Use case**: You have very few resources you want to generate IaC for and you have the time to grab all of their IDs and write filters for them.

#### By Tags

Tagging your resources is by far the easiest way to start with terraform code generation. Its also the simplest filtering strategy for Terraformer, and the fastest way to generate code.

If you don't have a tagging strategy there are plenty of best practice guides out there, including this one from [AWS](https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/defining-needs-and-use-cases.html).

**Do not let lack of tagging deter you, you can absolutely get started with no tagging strategy by implementing a basic strategy just for importing.**

The AWS CLI has a command for bulk tagging. You don't have to 100% have your tagging strategy down to start w/ Terraformer, you just need enough tags to generate the _right_ IaC code. Once you have IaC you'll be able to apply a broader tagging strategy to all of your resources.

And it's important to remember, you dont have to get IaC perfect the first time. DevOps is all about iterations and building on the foundation you have. The goal is to get resoruces under management and continue to improve over time.

You'll miss a resource, you won't get the perfect module interface. Thats ok. These are easy fixes once we have generated most of the code.

The easiest way to get started is to define a tag for labeling which Terraform module or git repo will be creating the resource. This can also be a throwaway tag just for importing your resources.

If you ran the Aurora AWS Postgres module, some tags have already been added for you. Run the command below to get a list of ARNs created by our original terraform code.

```shell
aws resourcegroupstaggingapi get-resources --region us-west-2 --tag-filters Key=Webinar,Values=opentofu | jq '[.ResourceTagMappingList[].ResourceARN]'
```

We are going to go ahead and pretend we _don't_ have tags, so I can show you how to apply a quick strategy for grouping resources together.

The first thing I do in an environment with no consistent tagging strategy that I need to terraform some resources, I get a list of all of the ARNs for the account, I'll then import this into a spreadsheet and break it down into individual worksheets of resource ARNs.

```shell
aws resourcegroupstaggingapi get-resources --region us-west-2 --output json > /tmp/resources.json; jq '[.ResourceTagMappingList[].ResourceARN]' /tmp/resources.json
```

For this tutorial, we will simply grep to get the relavent IDs:

```shell
jq '[.ResourceTagMappingList[].ResourceARN]' /tmp/resources.json | grep opentofu
```

We'll use a 'throwaway' tagging convention here and simply tag the resources with our module name `Module=aws-aurora-postgres`. This will make it easy for us to import below.

A throwaway tag is nice, you can omit the tag in your Terraform later to keep track of what resources YOU HAVE GOTTEN under management, or keep the tag on and use the resourcetagging api to confirm its under management by seeing the additional tags being present.

```shell
# Put your RESOURCE IDs from above here, in the same quoted format.

aws resourcegroupstaggingapi tag-resources --region us-west-2 --resource-arn-list 'arn:aws:rds:us-west-2:083014189801:cluster-snapshot:rds:webinar-test-opentofu-2024-04-17-06-02' 'arn:aws:rds:us-west-2:083014189801:db:webinar-test-opentofu-20240416195347790500000002' 'arn:aws:rds:us-west-2:083014189801:subgrp:webinar-test-opentofu' 'arn:aws:rds:us-west-2:083014189801:cluster:webinar-test-opentofu' --tags Module=aws-aurora-postgres
```

```shell
aws resourcegroupstaggingapi get-resources --region us-west-2 --tag-filters Key=Module,Values=aws-aurora-postgres | jq '[.ResourceTagMappingList[].ResourceARN]'
```

```shell
cd generated/by-tags
echo "provider \"aws\" {}" > provider.tf

# Terraformer needs files in a certain place/.
terraform init

# Generate database IaC
terraformer import aws --resources=rds,sg \
  --filter="Name=tags.Module;Value=aws-aurora-postgres" \
  --regions=us-west-2 \
  --path-output . \
  --path-pattern {output}

# Upgrade state, defaults to tf 0.13
terraform state replace-provider -auto-approve "registry.terraform.io/-/aws" "hashicorp/aws"

tofu init
tofu plan
```

This looks _pretty_ good.

Some notes:

* Security group rules are rolled into security groups by default
* Didn't get any of our "random" provider resources
* Got the wrong resource type again for the db instance -> WHY? Terraformer doesn't suppor that resource type :shrug: and its taking a best guess.
* variables.tf is useless

### Refactoring Terraformer Code

#### Prompts

rm variables.tf

cat *.tf | mods --word-wrap=1000 "Don't change any code besides what I ask. Do not omit any attributes under any circumstances. Return the full terraform code with the changes I've requested. I need the code back in a copy/pastable format, so under no circumstance omit code unless what I ask to be removed.

Remove tags_all, if all tags are consistent across resources, remove tags as well and move them to default_tags on the provider.

Rename all resources to 'main' if its the only one of that resource, if there are multiples of a resource collapse them into a single resource with a for_each block and rename the resource to 'main'. Give the outputs better names.

For any id, name, or arn attributes, reference what looks like the appropriate resource in this file instead of keeping the hard coded id/name/arn value. Make sure referencing any attributes is using the new resource names. Never try to create references to remote state or data lookups.

Do _NOT_ add any resources that aren't already in the file.

Never word wrap long lines.

Assume I have no local state file, but I do have a list of AWS resources that I need to import into this module. Give me the import commands to run for each resource. Feel free to put 'ARN_HERE' or 'ID_HERE' as placeholders.
"

Check out our next [webinar](https://streamyard.com/watch/Zfq5EjHYXJf2) on module design best practices where we will cover variables, interfaces, parity, and use case oriented design.
