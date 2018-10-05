#!/bin/sh

set -e

WORKING_DIR=$(pwd)
ENVIRONMENTS_DIR="$WORKING_DIR/environments"
ENVIRONMENTS=$(find "$ENVIRONMENTS_DIR"/* -maxdepth 0 -type d -exec basename '{}' \; | sort -n)

OVERALL_RETURN=0
for ENVIRONMENT in $ENVIRONMENTS; do
  echo "terraform fmt $ENVIRONMENT"

  cd "$ENVIRONMENTS_DIR/$ENVIRONMENT" && terraform fmt -check=true -write=false -diff=false -list=true && terraform get
  LINT_RETURN=$?

  if [ $LINT_RETURN -ne 0 ]
  then
    echo "Linting failed in $ENVIRONMENT please run terraform fmt"
    OVERALL_RETURN=1
  fi
done

for ENVIRONMENT in $ENVIRONMENTS; do
  echo "tflint $ENVIRONMENT"

  LINT_OUTPUT=$(cd "$ENVIRONMENTS_DIR/$ENVIRONMENT" && tflint)
  LINT_RETURN=$?

  if [ $LINT_RETURN -ne 0 ]
  then
    echo "Linting failed in $ENVIRONMENT, please run tflint and troubleshoot"
    echo $LINT_OUTPUT
    OVERALL_RETURN=1
  fi
done

if [ $OVERALL_RETURN -ne 0 ]
then
  exit $OVERALL_RETURN
fi
