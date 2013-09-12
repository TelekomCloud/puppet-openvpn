define openvpn::server(
  $dev = 'tun0',
  $ip = '0.0.0.0',
  $port = '443',
  $proto = 'tcp',
  $user = 'openvpn',
  $group = 'openvpn',
  $ca = 'keys/ca.crt',
  $key = 'keys/server.key',
  $crt = 'keys/server.crt',
  $dh = 'keys/dh1024.pem',
  $ipp = false,
  $ip_pool = [],
  $compression = 'comp-lzo',
  $logfile = false,
  $status_log = "${name}/openvpn-status.log",
  $verb = 3,
  $pamlogin = false
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
  # sudo adduser --system --no-create-home --disabled-login --ingroup openvpn openvpn 
  ->group { "${group}":
    ensure => present,
    system => true,
  }
  ->user { "${user}":
    ensure => present,
    comment => "openvpn user",
    gid => "${group}",
    membership => minimum,
    shell => "/sbin/nologin",
    home => "/dev/null",
    system => true,
  }
  
  ->file {
    "/etc/openvpn/${name}.conf":
      owner   => root,
      group   => root,
      mode    => '0444',
      content => template('openvpn/server.erb');
  }

  ->file {
    "/etc/openvpn/${name}":
      ensure  => directory,
      recurse => true,
      owner   => 'root', group => ', mode => '0755',
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
