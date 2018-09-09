#!/bin/sh

set -e

WORKING_DIR=$(pwd)
mkdir -p "$WORKING_DIR/artifacts"
ARTIFACTS_BUCKET="meyrickblog-tfstate"
ARTIFACTS_DIR="$WORKING_DIR/artifacts"
ENVIRONMENTS_DIR="$WORKING_DIR/environments"

if [ -f "$ARTIFACTS_DIR/changed_envs_$(git rev-parse --short HEAD)" ]; then
  ENVIRONMENTS=$(cat "$ENVIRONMENTS_DIR/changed_envs_$(git rev-parse --short HEAD)" | sort -n)
else
  ENVIRONMENTS=$(find "$ENVIRONMENTS_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)
fi

for ENVIRONMENT in $ENVIRONMENTS; do
  # for debugging, show that these files exist
  ls -la "$ARTIFACTS_DIR/"

  echo "Copying plan file for $ENVIRONMENT"
  aws s3 cp s3://$ARTIFACTS_BUCKET/artifacts/terraform.$ENVIRONMENT.$(git rev-parse --short HEAD).plan $ARTIFACTS_DIR

  echo "terraform init  $ENVIRONMENT"
  (cd "$ENVIRONMENTS_DIR/$ENVIRONMENT" && terraform init)

  echo "terraform apply $ENVIRONMENT"
  (cd "$ENVIRONMENTS_DIR/$ENVIRONMENT" && terraform apply -input=false -no-color "$ARTIFACTS_DIR/terraform.$ENVIRONMENT.$(git rev-parse --short HEAD).plan")
  if [ -f "$ENVIRONMENTS_DIR/$ENVIRONMENT/aws_hosts" ]; then
  (cd "$ENVIRONMENTS_DIR/$ENVIRONMENT" && aws s3 cp aws_hosts s3://$ARTIFACTS_BUCKET/artifacts/)
  fi
done
