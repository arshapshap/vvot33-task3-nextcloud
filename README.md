## Screenshots
### The usual flow:
![telegram-cloud-photo-size-2-5312184348658759477-y](https://github.com/user-attachments/assets/06748641-036c-4688-9c63-2d220d03e885)
![telegram-cloud-photo-size-2-5312184348658759475-y](https://github.com/user-attachments/assets/8de619c3-8a96-4d44-8470-1757fe57cc48)
![telegram-cloud-photo-size-2-5312109556098263118-y](https://github.com/user-attachments/assets/6039243f-5f4d-4edd-8d5d-31ffb94f5abc)


<details>
<summary>

### Errors
</summary>

![telegram-cloud-photo-size-2-5312184348658759474-y](https://github.com/user-attachments/assets/b785ea06-0429-4eb5-ba5d-dbfa799a7118)
![telegram-cloud-photo-size-2-5312184348658759472-y](https://github.com/user-attachments/assets/f34a4b8b-aab3-4dc5-b85e-e152946482f6)
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

- Run server:
```
./setup_server.sh
```

- Open website:
```
https://vvot33.itiscl.ru
```

- Destroy server after using:
```
./destroy_server.sh
```
