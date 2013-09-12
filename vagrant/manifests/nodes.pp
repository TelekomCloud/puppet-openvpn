node "precise.openvpn.local" {
  openvpn::server { 'midnight':
    # we want to be running in 2-factor auth mode
    pamlogin => true,
    # all of these are optional...
    dev => 'tun0',
    ip => '0.0.0.0',
    port => '443',
    proto => 'tcp',
    ccd => 'ccd',
    ccd_exclusive => true;
  }
}

node "puppetmaster.local" {
}
