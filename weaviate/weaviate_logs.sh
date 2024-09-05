#!/bin/bash

namespace=${1:-weaviate}


# Create a directory to store the logs
mkdir -p pod-logs-$namespace

# Get the names of all pods in the namespace
pods=$(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')

# Loop through each pod and get its logs
for pod in $pods; do
    kubectl logs $pod -n $namespace > pod-logs-$namespace/$pod.log
done

echo "Logs collected in pod-logs-$namespace/ directory."

