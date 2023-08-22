let 
  githubPub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG95H6L3N+gXc6JFj5Gyr0uvl5AfzhBdbUj8l3gUWbiq";
in
{
  "github.age".publicKeys = [ githubPub ];
}
