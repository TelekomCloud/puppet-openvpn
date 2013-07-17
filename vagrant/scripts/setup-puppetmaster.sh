cp /vagrant/fileserver.conf /etc/puppet/fileserver.conf

apt-get update
apt-get install -y openvpn

puppet master --mkusers --autosign true
