resource "yandex_vpc_network" "network" {
  name = "vvot33-nextcloud-server-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name              = "vvot33-nextcloud-server-subnet" 
  zone              = "ru-central1-a"
  v4_cidr_blocks    = ["192.168.10.0/24"]
  network_id        = yandex_vpc_network.network.id
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts-oslogin"
}

resource "yandex_compute_disk" "boot-disk" {
  name = "vvot33-nextcloud-server-boot-disk"
  type = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu.id
  size = 10
}

resource "yandex_compute_instance" "nextcloud-vm" {
  name = "vvot33-nextcloud-server"
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

resource "yandex_dns_zone" "zone" {
  zone   = "vvot33.itiscl.ru."
  public = true
}

resource "yandex_dns_recordset" "project-record" {
  zone_id = yandex_dns_zone.zone.id
  name    = "project"
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.nextcloud-vm.network_interface.0.nat_ip_address]
}

output "vm_external_ip" {
  value = yandex_compute_instance.nextcloud-vm.network_interface.0.nat_ip_address
}

resource "null_resource" "set-ansible-host" {
    provisioner "local-exec" {
        command = "sed -i '' -e 's/{IP}/${yandex_compute_instance.nextcloud-vm.network_interface[0].nat_ip_address}/g' ansible/inventory.ini"
    }
    provisioner "local-exec" {
        when    = destroy
        command = "sed -i '' -e 's/[0-9]\\{1,3\\}\\(.[0-9]\\{1,3\\}\\)\\{3\\}/{IP}/g' ansible/inventory.ini"
    }
    depends_on = [yandex_compute_instance.nextcloud-vm]
}

resource "null_resource" "add-known-host" {
    provisioner "local-exec" {
        command = "ssh-keyscan -T 240 -H ${yandex_compute_instance.nextcloud-vm.network_interface[0].nat_ip_address} >> ~/.ssh/known_hosts"
    }
    depends_on = [yandex_compute_instance.nextcloud-vm]
}