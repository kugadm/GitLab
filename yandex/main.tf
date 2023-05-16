terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "" # OAuth-токен яндекса
	# не обязательный параметр (берется облако по умолчанию),
	# хотя в документации написано иначе
  cloud_id  = "b1gkrsug90ki2ea2tktr"
  folder_id = "b1g5al4i33kri603g6g2"
  zone      = "ru-central1-b"
}

data "yandex_compute_image" "last_ubuntu" {
  family = "ubuntu-2204-lts"  # ОС (Ubuntu, 22.04 LTS)
}

data "yandex_vpc_subnet" "default_a" {
  name = "default-ru-central1-b"  # одна из дефолтных подсетей
}

# ресурс "yandex_compute_instance" т.е. сервер
# Terraform будет знаеть его по имени "yandex_compute_instance.default"
resource "yandex_compute_instance" "default" {
  name = "vagrant2"
  platform_id = "standard-v3" # тип процессора (Intel Broadwell)
  metadata = {
  ssh-keys = "vagrant:${file("/home/key.public")}"
  }

resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores  = 2 # vCPU
    memory = 2 # RAM
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.last_ubuntu.id # ОС (Ubuntu, 22.04 LTS)
      size = 10
    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.default_a.subnet_id # одна из дефолтных подсетей
    nat = true # автоматически установить динамический ip
    nat_ip_address = "51.250.100.25"
  }
}

