#!/bin/bash

# Function to list Azure resources by multiple tags and extract their IDs
function azure_resource_list_and_tags() {
    local key1="${1%%=*}"
    local value1="${1#*=}"
    local key2="${2%%=*}"
    local value2="${2#*=}"
    
    az resource list --tag "$key1=$value1" --tag "$key2=$value2" | jq -r "[.[] | select(.tags[\"$key1\"] == \"$value1\" and .tags[\"$key2\"] == \"$value2\") | .id]"
}

# Function to list AWS resources by multiple tags and extract their IDs/ARNs
function aws_resource_list_and_tags() {
    local key1="${1%%=*}"
    local value1="${1#*=}"
    local key2="${2%%=*}"
    local value2="${2#*=}"
    
    aws resourcegroupstaggingapi get-resources --tag-filters Key="$key1",Values="$value1" Key="$key2",Values="$value2" --query 'ResourceTagMappingList[].ResourceARN' --output json
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <cloud> <key1=value1> <key2=value2>"
    echo "Example: $0 aws md-project=geniac md-target=staging"
    echo "Example: $0 azure md-project=geniac md-target=staging"
    exit 1
fi

# Get the cloud provider and tags
cloud="$1"
tag1="$2"
tag2="$3"

# Call the appropriate function based on the cloud provider
case "$cloud" in
    azure)
        azure_resource_list_and_tags "$tag1" "$tag2"
        ;;
    aws)
        aws_resource_list_and_tags "$tag1" "$tag2"
        ;;
    *)
        echo "Unsupported cloud provider: $cloud"
        echo "Supported providers are: aws, azure"
        exit 1
        ;;
esac
