## Screenshots
### The usual flow:
![telegram-cloud-photo-size-2-5312109556098263394-y](https://github.com/user-attachments/assets/8b50d2ad-186e-446d-968e-1a466a5d01af)
![telegram-cloud-photo-size-2-5314436148472441982-y](https://github.com/user-attachments/assets/1a8fa9aa-3b5e-4dc0-89c5-adacdfd31c0d)
![telegram-cloud-photo-size-2-5314436148472442013-y](https://github.com/user-attachments/assets/496015bc-97fa-4102-ab63-5f23eab674ae)
![telegram-cloud-photo-size-2-5314436148472442017-y](https://github.com/user-attachments/assets/95b3ccff-8275-4e89-856e-7b4fbf721af9)
![telegram-cloud-photo-size-2-5314436148472442014-y](https://github.com/user-attachments/assets/23d7bb3f-4275-4fb2-97fc-0499999974a6)
![telegram-cloud-photo-size-2-5314436148472442025-y](https://github.com/user-attachments/assets/5188e70a-bc52-437e-8c1c-c91849163673)

<details>
<summary>

### Errors
</summary>

![telegram-cloud-photo-size-2-5312109556098263490-y](https://github.com/user-attachments/assets/6a6f9948-62bc-4d00-9f8e-63da96b87aec)
![telegram-cloud-photo-size-2-5314436148472442030-y](https://github.com/user-attachments/assets/4f78c0f2-fa19-46e4-9545-2d70f5d5f8e4)
</details>

## Setup
- Go to folder `server`:
```
cd server
```

- Create file `terraform.tfvars`:
```
cloud_id  = "<value>"
folder_id = "<value>"
```

- Fill in variables in file `ansible/smtp-vars.yml`:
```
email: <YOUR_EMAIL>
smtp_host: <YOUR_SMTP_HOST>
smtp_password: <YOUR_SMTP_PASSWORD>
smtp_port: <YOUR_SMTP_PORT>
smtp_secure: <YOUR_SMTP_SECURE>
```

- Run server:
```
./setup_server.sh
```

The website will be accessible via the link specified in the `domain` variable of the Terraform configuration (https://vvot33.itiscl.ru by default).

- Destroy server after using:
```
./destroy_server.sh
```
