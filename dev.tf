resource "digitalocean_project" "eleveo" {
  name        = "eleveo"
  description = "eleveo homework workspace"
  environment = "Development"
  resources   = [digitalocean_droplet.dev.urn]
}

resource "digitalocean_droplet" "dev" {
    image = "centos-stream-8-x64"
    name = "dev"
    region = "fra1"
    size = "s-2vcpu-4gb-amd"
    ssh_keys = [
      data.digitalocean_ssh_key.mbpsporka.id
    ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "dnf repolist",
      "for i in {1..60}; do echo Giving cloud-init time to finish $${i}/60 seconds; sleep 1; done",
      "dnf update --assumeyes",
      "dnf install wget --assumeyes",
      "wget -q https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo",
      "dnf install VirtualBox-6.1.x86_64 --assumeyes",
      "wget -q https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo -O /etc/yum.repos.d/hashicorp.repo",
      "dnf install vagrant --assumeyes",
      "dnf install python39 --assumeyes",
      "pip3 install --upgrade pip setuptools",
      "pip3 install ansible==4.10.0"
    ]
  }

}

