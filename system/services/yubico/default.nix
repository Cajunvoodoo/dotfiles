{
  config,
  pkgs,
  ...
}: {
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    ssdm.u2fAuth = true;
    kwallet5.u2fAuth = true;
  };
}
