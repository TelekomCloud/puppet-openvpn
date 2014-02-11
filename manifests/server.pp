    # == Define: OpenVPN Server
    #
    # Setting up a server based OpenServer configuration without
    # creation of any SSL Certs.
    #
    # === Parameters
    #
    # [*proto*]
    #   IPv4 udp or tcp
    #   IPv6 udp6 or tcp6
    #   Defines the L4 protocol you want to used. The usage of IPv4 and IPv6 at
    #   the same time is possible.
    #
    # [*server6*]
    #   ipv6addr/bits
    #   Enabling IPv6 helper directive of OpenVPN and will allocate given
    #   address for server and client. Will bind to first IP of the network.
    #
    #
    # === Examples
    #
    #  IPv6 example without two-factor and one IPv4/IPv6 address for clients:
    #     openvpn::server { 'testlord':
    #      dev     => 'tun0',
    #      ip      => '10.0.0.2',
    #      port    => '443',
    #      proto   => 'tcp, tcp6',
    #      dh      => 'keys/dh4096.pem',
    #      ipp     => 'true',
    #      server  => '172.17.28.0 255.255.255.0',
    #      server6 => 'fc00:dead::1/65',
    #      push    => 'route 172.17.27.0 255.255.255.0',
    #      route   => '172.17.27.0 255.255.255.0',
    #  }
    #
    #
    # === Authors
    #
    # Dominik Richter <do.richter@telekom.de>
    # Kurt Huwig <k.huwig@telekom.de>
    # Jan Alexander Slabiak <4k3nd0@gmail.com>
    #
    # === Copyright
    #
    # Copyright:: 2013, Deutsche Telekom AG,  Apache License, Version 2.0
    #

define openvpn::server(
  $dev               = 'tun0',
  $ip                = '0.0.0.0',
  $port              = '443',
  $proto             = 'tcp',
  $user              = 'openvpn',
  $group             = 'openvpn',
  $ca                = 'keys/ca.crt',
  $key               = 'keys/server.key',
  $crt               = 'keys/server.crt',
  $dh                = 'keys/dh1024.pem',
  $ipp               = false,
  $ccd               = false,
  $ccd_exclusive     = false,
  $ip_pool           = [],
  $compression       = 'comp-lzo',
  $logfile           = false,
  $status_log        = "${name}/openvpn-status.log",
  $verb              = 3,
  $pamlogin          = false,
  $client_connect    = undef,
  $client_disconnect = undef,
  $topology          = undef,
  $server            = undef,
  $server6           = undef,
  $push              = [],
  $up                = undef,
  $down              = undef,
  $route             = undef,
  $bettercrypto      = true,
) {

  $tls_server = $proto ? {
    /tcp/   => true,
    default => false
  }

  package { 'openvpn':
    ensure => installed;
  }

  # make user the user and group exist
  # sudo addgroup --system --no-create-home --disabled-login --group openvpn
  # sudo adduser --system --no-create-home --disabled-login \
  #              --ingroup openvpn openvpn
  ->group { $group:
    ensure => present,
    system => true,
  }
  ->user { $user:
    ensure     => present,
    comment    => 'openvpn user',
    gid        => $group,
    membership => minimum,
    shell      => '/sbin/nologin',
    home       => '/dev/null',
    system     => true,
  }

  ->file {
    "/etc/openvpn/${name}.conf":
      owner   => 'root',
      group   => 'openvpn',
      mode    => '0440',
      content => template('openvpn/server.erb');
  }

  ->file {
    "/etc/openvpn/${name}":
      ensure  => directory,
      recurse => true,
      owner   => 'root',
      group   => 'openvpn',
      mode    => '0750',
      source  => "puppet:///openvpn/${name}";
  }

  ->service {
    'openvpn':
      ensure      => running,
      enable      => true,
      hasrestart  => true,
      hasstatus   => true;
  }
}
