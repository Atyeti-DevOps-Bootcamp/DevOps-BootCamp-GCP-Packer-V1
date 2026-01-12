#!/bin/bash
set -e

echo "Fetching VM details from Terraform..."

cd terraform-gcp

VM_NAME=$(terraform output -raw vm_name)
VM_IP=$(terraform output -raw vm_ip)

if [[ -z "$VM_IP" ]]; then
  echo "Failed to fetch VM IP"
  exit 1
fi

echo "VM Name: $VM_NAME"
echo "VM IP: $VM_IP"

cd ..

echo "Waiting for VM SSH to be ready..."
sleep 60

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

echo "Connecting to VM via SSH..."

ssh $SSH_OPTS admin@"$VM_IP" << 'EOF'
set -e

echo "Checking admin user..."
id admin >/dev/null 2>&1 || {
  echo "admin user does not exist"
  exit 1
}

echo "Checking user1 user..."
id user1 >/dev/null 2>&1 || {
  echo "user1 user does not exist"
  exit 1
}

echo "Checking admin sudo access..."
sudo -l -U admin >/dev/null 2>&1 || {
  echo "admin does NOT have sudo access"
  exit 1
}

echo "Checking user1 sudo access (MUST FAIL)..."
if sudo -l -U user1 >/dev/null 2>&1; then
  echo "SECURITY VIOLATION: user1 has sudo access"
  exit 1
fi

echo "SECURITY CHECK PASSED"
echo "admin has sudo"
echo "user1 has NO sudo"
EOF
