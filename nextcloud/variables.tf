variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}
variable "folder_id" {
  description = "Folder ID"
  type        = string
}
variable "domain" {
  description = "Domain"
  type        = string
  default     = "vvot33.itiscl.ru"
}
variable "dns_zone_id" {
  description = "DNS Zone ID"
  type        = string
}