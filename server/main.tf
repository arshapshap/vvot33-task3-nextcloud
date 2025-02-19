terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone                      = "ru-central1-a"
  service_account_key_file  = pathexpand("~/.yc-keys/key.json")
  cloud_id                  = var.cloud_id
  folder_id                 = var.folder_id
}

resource "yandex_vpc_network" "network" {
  name = "vvot33-server-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name              = "vvot33-server-subnet" 
  zone              = "ru-central1-a"
  v4_cidr_blocks    = ["192.168.10.0/24"]
  network_id        = yandex_vpc_network.network.id
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts-oslogin"
}

resource "yandex_compute_disk" "boot-disk" {
  name = "vvot33-server-boot-disk"
  type = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu.id
  size = 10
}

resource "yandex_compute_instance" "server-vm" {
  name = "vvot33-server-vm"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "null_resource" "add-known-host" {
    provisioner "local-exec" {
        command = "ssh-keyscan -T 240 -H ${yandex_compute_instance.server-vm.network_interface[0].nat_ip_address} >> ~/.ssh/known_hosts"
    }
    depends_on = [yandex_compute_instance.server-vm]
}

resource "null_resource" "add-ip-to-inventory" {
    provisioner "local-exec" {
        command = "sed -i '' \"s/{IP}/${yandex_compute_instance.server-vm.network_interface[0].nat_ip_address}/g\" ansible/inventory.ini"
    }
    provisioner "local-exec" {
        when    = destroy
        command = "sed -i '' -e \"s/[0-9]\\{1,3\\}\\(.[0-9]\\{1,3\\}\\)\\{3\\}/{IP}/g\" ansible/inventory.ini"
    }
    depends_on = [yandex_compute_instance.server-vm]
}

output "server-vm-ip" {
    value = yandex_compute_instance.server-vm.network_interface[0].nat_ip_address
}