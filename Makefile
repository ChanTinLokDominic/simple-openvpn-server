set-up:
	sudo apt update

#Uninstall Docker Engine
	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Install Docker Engine
	sudo apt install -y ca-certificates curl gnupg
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo usermod -aG docker $(whoami) 

# Install Docker-Compose
	sudo apt install -y python3-pip
	pip install --upgrade pip
	pip install docker==6.1.3 docker-compose==1.29.2

export PUBIC_IP=$(shell curl -4 icanhazip.com)
start:
	docker-compose run --rm openvpn-server ovpn_genconfig -u udp://${PUBIC_IP}
	docker-compose run --rm openvpn-server ovpn_initpki
	docker-compose up -d

export CLIENT_NAME?=
create-client:
	docker-compose run --rm openvpn-server easyrsa build-client-full ${CLIENT_NAME} nopass
	mkdir -p -m 700 client_keys
	docker-compose run --rm openvpn-server ovpn_getclient ${CLIENT_NAME} > client_keys/${CLIENT_NAME}.ovpn
	chmod 600 client_keys/${CLIENT_NAME}.ovpn

remove-client:
	rm ./client_keys/${CLIENT_NAME}.ovpn
	docker exec openvpn-server rm /etc/openvpn/pki/private/${CLIENT_NAME}.key /etc/openvpn/pki/reqs/${CLIENT_NAME}.req /etc/openvpn/pki/issued/${CLIENT_NAME}.crt

stop:
	docker-compose down