#!/bin/bash
set -e

bosh target $BOSH_TARGET
bosh deployment $BOSH_MANIFEST
bosh run errand acceptance_tests
