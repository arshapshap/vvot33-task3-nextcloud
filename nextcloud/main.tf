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
  name = "vvot33-nextcloud-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name              = "vvot33-nextcloud-subnet" 
  zone              = "ru-central1-a"
  v4_cidr_blocks    = ["192.168.10.0/24"]
  network_id        = yandex_vpc_network.network.id
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts-oslogin"
}