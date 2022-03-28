PICAMIP := 192.168.2.55
PICAMUSER := pi
PICAMFOLDER := /home/pi/piIpCam
PIHOUSEIP := 192.168.2.47
PIHOUSEUSER := pi
PIHOUSEFOLDER := /home/pi/piIpCam
# start_vnc:
# 	x11vnc -display :0

prepare:
	sudo apt-get update && sudo apt install -y python3.7-dev python3-distutils uwsgi uwsgi-src uuid-dev libcap-dev libpcre3-dev libpython3.7-dev libpython3-all-dev uwsgi-plugin-python3 uwsgi build-essential nginx

prepare_resources:
	sudo cp resources/nginx/cam.conf /etc/nginx/sites-available \
    && sudo ln -s /etc/nginx/sites-available/cam.conf /etc/nginx/sites-enabled \
    && sudo service nginx restart

# install_vnc:
# 	sudo apt-get install -y x11vnc net-tools

install_cam:
	pip3 install -r requirements.txt

test_cam:
	python3 scripts/testcam.py

sync_cam_piclock:
	rsync -av --exclude={'venv','.idea','__pycache__','.git'} ./ ${PICAMUSER}@${PICAMIP}:${PICAMFOLDER}

sync_cam_pihouse:
	rsync -av --exclude={'venv','.idea','__pycache__','.git'} ./ ${PIHOUSEUSER}@${PIHOUSEIP}:${PIHOUSEFOLDER}

start_uwsgi_cam:
	uwsgi resources/uwsgi/uwsgi_cam.ini --enable-threads

start_uwsgi_sec:
	uwsgi resources/uwsgi/uwsgi_sec.ini