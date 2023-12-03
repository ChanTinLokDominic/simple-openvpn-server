# Introduction
A simple dockerized vpn server based on the repo `https://github.com/kylemanna/docker-openvpn`

# Requirements
- docker
- docker-compose

# Usage
## Start the vpn server
```bash
make start
```
Follow the prompt and 
- Enter the passphrase of the CA Key **(DO NOT FORGET THE PASSPHRASE!!)**
- Define the common name of the CA server
- Re-enter the passphrase of the CA Key two times

Please notice that you need the passphrase to create clients in the next stage.


## Create a client
The key of the newly created client will be stored in `simple-openvpn-server/client_keys`
```bash
make create-client CLIENT_NAME=<name-of-client>
```

## Stop the server
```bash
make stop
```