#!/bin/bash

set -x
set -eo pipefail

WORKSHOP_NAME=lab-building-images
SPAWNER_APPLICATION=${SPAWNER_APPLICATION:-$WORKSHOP_NAME}
SPAWNER_NAMESPACE=`oc project --short`

oc delete all --selector build="$WORKSHOP_NAME"
