build {
  name    = "gcp-base-image"
  sources = ["source.googlecompute.base"]

  provisioner "shell" {
    inline = [
      "set -eu",

      # Wait for cloud-init
      "sudo cloud-init status --wait",

      # Disable background apt services
      "sudo systemctl stop apt-daily.service apt-daily-upgrade.service unattended-upgrades || true",
      "sudo systemctl disable apt-daily.service apt-daily-upgrade.service unattended-upgrades || true",
      "sudo systemctl mask apt-daily.service apt-daily-upgrade.service unattended-upgrades || true",

      "sudo systemctl stop apt-daily.timer apt-daily-upgrade.timer || true",
      "sudo systemctl disable apt-daily.timer apt-daily-upgrade.timer || true",
      "sudo systemctl mask apt-daily.timer apt-daily-upgrade.timer || true",

      # Wait for apt locks
      "while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 5; done",
      "while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do sleep 5; done",
      "while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 5; done",

      # Recover apt
      "sudo rm -rf /var/lib/apt/lists/partial/*",
      "sudo apt-get clean",
      "sudo dpkg --configure -a",

      # Core packages
      "sudo DEBIAN_FRONTEND=noninteractive apt-get update -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3",

      # Ansible temp dir
      "sudo mkdir -p /tmp/.ansible",
      "sudo chmod 777 /tmp/.ansible"
    ]
  }
}
