#!/bin/bash

namespace==${1:-weaviate}

# Get all pod names in the specified namespace
pod_names=$(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')

while true; do

    status_line=""

    # Loop through each pod and check if it's ready
    for pod_name in $pod_names; do
        ready=$(kubectl get pod $pod_name -n $namespace -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
        if [ "$ready" == "True" ]; then
            status_line+="Pod $pod_name: ready, "
        else
            status_line+="Pod $pod_name: not ready, "
        fi
    done

    # Get the timestamp and the node information
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    output=$(curl -s http://localhost:8080/v1/nodes | jq ".nodes | length")
    
    echo "$timestamp - $status_line Nodes: $output"
    
    sleep 1
done

