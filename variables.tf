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
variable "project_name" {
  description = "User project name"
  type        = string
}
variable "email" {
  description = "User email"
  type        = string
}
variable "password" {
  description = "User password for nextcloud"
  type        = string
}