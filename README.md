# OpenVPN for Puppet

Puppet module for OpenVPN.

## Usage

Set up the server on a node:

    openvpn::server { 'midnight': }

For a full list of configuration options look at `manifests/server.pp`.

## Examples

2-Factor authentication with password and certificate, TCP on port `443`:

    openvpn::server { 'midnight':
      # we want to be running in 2-factor auth mode
      pamlogin => true,
      # all of these are optional...
      dev => 'tun0',
      ip => '192.168.123.32',
      port => '443',
      proto => 'tcp',
    }

## Vagrant

Look into `vagrant` folder. You can simply:

    cd vagrant
    vagrant up

    vagrant ssh puppetmaster
    # puppet master also acts as the openvpn client

    # inside puppetmaster:
    sudo -i
    cd /etc/openvpn/client
    openvpn client.conf
    # username: vagrant
    # password: vagrant


## Differences to other implementations

* `luxflux-openvpn` (https://github.com/luxflux/puppet-openvpn)[https://github.com/luxflux/puppet-openvpn]
  `luxflux-openvpn` is a full-fledged implementation that includes key/cert-generation and handling. If you want that, I highly recommend this module. If you want to manage keys/certs differently and only let puppet install OpenVPN without taking over secrets management, then use this module instead.


## Kudos and references

* This puppet module is partly inspired by `luxflux-openvpn`. Some pieces of code from this project were used as well.
* Thanks to Diana Bucuci for 2-factor OpenVPN!


# License and Author

Author:: Dominik Richter <do.richter@telekom.de>  
Copyright:: 2013, Deutsche Telekom AG

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

