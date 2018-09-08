#!/bin/sh

set -e

WORKING_DIR=$(pwd)
mkdir -p "$WORKING_DIR/artifacts"
ARTIFACTS_DIR="$WORKING_DIR/artifacts"
ENVIRONMENTS_DIR="$WORKING_DIR/environments"

ENVIRONMENTS=$(find "$ENVIRONMENTS_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)


for ENVIRONMENT in $ENVIRONMENTS; do
  echo "terraform init $ENVIRONMENT"
  (cd "$ENVIRONMENTS_DIR/$ENVIRONMENT" && terraform init -input=false -no-color)

  # cache .terraform during the plan
  (cd "$ENVIRONMENTS_DIR/$ENVIRONMENT" && tar -czf "$ARTIFACTS_DIR/.terraform.$ENVIRONMENT.$(git rev-parse --short HEAD).tar.gz" .terraform)

  echo "terraform plan $ENVIRONMENT"
  (cd "$ENVIRONMENTS_DIR/$ENVIRONMENT" && terraform plan -no-color -input=false -out="$ARTIFACTS_DIR/terraform.$ENVIRONMENT.$(git rev-parse --short HEAD).plan" | tee "$ENVIRONMENTS_DIR/full_plan_output.log" | grep -v "Refreshing state" )

  # AWS Sync Artifacts to S3
  aws s3 sync "$ARTIFACTS_DIR" s3://meyrickblog-tfstate/artifacts

  # for debugging, show these files exist
  echo "The following artifacts have been stored"
  ls -la "$ARTIFACTS_DIR/.terraform.$ENVIRONMENT.$(git rev-parse --short HEAD).tar.gz"
  ls -la "$ARTIFACTS_DIR/terraform.$ENVIRONMENT.$(git rev-parse --short HEAD).plan"
done
