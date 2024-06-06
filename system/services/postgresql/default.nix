{pkgs, ...}: {
  config.services.postgresql = {
    enable = true;
    enableTCPIP = true;

    ensureDatabases = ["backend"];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      #--------------- IPv4
      #type database DBuser origin-address auth-method
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "init-sql-script" ''
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
      CREATE EXTENSION IF NOT EXISTS "pgcrypto";
    '';
  };
}
