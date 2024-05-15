# Generating OpenTofu Code from Existing Azure Resources

What do OpenTofu, Terraform, Azure, JQ, bash, mods, and OpenAI have in common?

Not much besides they'll be all up in your shell if you want to generate IaC with any sort of speed.

The key to doing this quickly is having a good tagging (or at least naming) convention. Naming conventions are difficult retroactively because: a) some resources can't be named b) renaming stuff sometimes destroys it

Before doing any IaC, I come up with at least a basic tagging strategy and go apply it to resources. You can do a full fledged one or something temporary like "iac-gen-wip=yourname" to make it easy if you have multiple people on your team generating IaC.

```shell
az resource list --tag md-project=geniac --tag md-target=staging | jq '.[].id'
# OR :(

# AND !
az resource list --tag md-project=geniac --tag md-target=staging | jq -r '.[] | select(.tags["md-project"] == "geniac" and .tags["md-target"] == "staging") | .id'

./hack/list_resource_by_tags.sh azure "md-project=geniac" "md-target=staging"
# ./hack/list_resource_by_tags.sh aws md-project=demo md-target=staging

./hack/list_resource_by_tags.sh azure "md-project=geniac" "md-target=staging" > resources.json

# Make sure to set your mods config to like 100+ characters wide or it'll put new lines in long strings like Subscription ID URLs which is invalid terraform.
cat prompts/generate resources.json | mods -r

mods -s 44e525a

tofu init
tofu plan -generate-config-out=generated.tf
```



Diff the output, back it out to vars/locals
Generate tfstate
