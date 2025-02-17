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
    memory = 2
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

output "vm_external_ip" {
  value = yandex_compute_instance.nextcloud-vm.network_interface.0.nat_ip_address
}
