#!/usr/bin/env bash
set -euo pipefail

echo "=== Basic repository security checks ==="

if grep -RInE --exclude-dir=.git --exclude='security-scan.sh' \
  '(AKIA[0-9A-Z]{16}|aws_secret_access_key|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY)' .; then
  echo "Potential credential/private-key pattern found. Review the files."
  exit 1
fi

if find . -name '*.tfstate' -o -name '*.tfstate.*' | grep -q .; then
  echo "Terraform state file found. Do not commit Terraform state."
  exit 1
fi

echo "No basic credential or Terraform-state patterns detected."
