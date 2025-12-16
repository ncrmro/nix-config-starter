# This file (`secrets.nix`) controls who can access your encrypted secrets.
# It is used by the `agenix` CLI tool to determine which SSH keys are allowed
# to decrypt specific secret files.
#
# How Agenix Works:
# 1. You define public SSH keys for "users" (people) and "systems" (machines).
# 2. You specify which keys can decrypt which secret file (`.age`).
# 3. When you run `agenix -e secrets/my-secret.age`, the tool uses these rules
#    to encrypt the content with *all* the allowed public keys.
# 4. At runtime, the NixOS system (or user) uses its private SSH key to decrypt
#    the secret file.
#
# Workflow:
# - Update this file when you add new users, systems, or secrets.
# - After modifying this file, run `agenix -r` to re-encrypt existing secrets
#   with the new key configuration (e.g., if you added a new server).

let
  # --------------------------------------------------------------------------------
  # Users
  # Public SSH keys for human users. These keys allow you to edit the secrets
  # using the `agenix -e` command.
  # Get these from your ~/.ssh/id_ed25519.pub or similar.
  # --------------------------------------------------------------------------------
  users = {
    # Replace these with your actual public keys
    jdoe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILoremIpsumDolorSitAmetConsectetur jdoe@jdoe-workstation";
  };

  # --------------------------------------------------------------------------------
  # Systems
  # Public SSH keys for your machines (NixOS hosts).
  # These keys allow the servers to decrypt secrets during system activation.
  # Get these from /etc/ssh/ssh_host_ed25519_key.pub on the target machine.
  # --------------------------------------------------------------------------------
  systems = {
    # Replace these with your actual host public keys
    jdoe-workstation = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdipiscingElitSedDoEiusmodTempor jdoe-workstation";
    jdoe-macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIncididuntUtLaboreEtDolore jdoe-macbook";
    jdoe-home-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMagnaAliquaUtEnimAdMinim jdoe-home-server";
  };

  # --------------------------------------------------------------------------------
  # Groups / Aliases
  # Group keys together for convenience (e.g., "all admins", "all web servers").
  # --------------------------------------------------------------------------------
  adminKeys = [ users.jdoe ];
  # allServers = [ systems.jdoe-workstation systems.jdoe-home-server ];

in
{
  # --------------------------------------------------------------------------------
  # Secret Rules
  # Map a secret file (relative path) to a list of public keys that can decrypt it.
  # --------------------------------------------------------------------------------

  # Example: Cloudflare API token for ACME DNS-01 challenge.
  # This secret can be decrypted by:
  # 1. The 'jdoe' user (so you can edit it)
  # 2. The 'jdoe-home-server' (so it can use the token for SSL validation)
  "secrets/cloudflare-api-token.age".publicKeys = adminKeys ++ [ systems.jdoe-home-server ];

  # Example: A secret only for the workstation
  # "secrets/wifi-password.age".publicKeys = adminKeys ++ [ systems.jdoe-workstation ];

  # Example: A secret shared by multiple servers
  # "secrets/vpn-shared-key.age".publicKeys = adminKeys ++ [ systems.jdoe-workstation systems.jdoe-home-server ];
}