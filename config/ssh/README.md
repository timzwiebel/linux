# SSH

[TOC]

## Install
> IMPORTANT: The `id_*.pub` files in this repository are my public SSH keys. You
> should use your own public SSH keys.

```shell
ln -s linux/config/ssh .ssh
```

## Generating keys
```shell
ssh-keygen -t ed25519 -a 100 -C '<your_email>'
```

This will generate a private key file `id_ed25519` and a public key file
`id_ed25519.pub` in the `~/.ssh/` directory using the Ed25519 elliptic curve
signature with 100 "rounds" and your email address as the "comment".

## Changing the private key password
```shell
ssh-keygen -p -a 100 -f ~/.ssh/id_ed25519
```
