# SSH Configuration


# Install
> **&#10071;&#65039;<!-- red exclamation mark emoji --> IMPORTANT:** The
> `id_*.pub` files in this repository are **my** public SSH keys. You should use
> **your own** public SSH keys.
>
> Therefore, it's probably not very useful for anyone else to use any files from
> this `config/ssh/` directory. However, some files might be helpful as
> templates for your own SSH configuration.

```shell
ln -s "${TIMZWIEBEL_LINUX}/config/ssh" ~/.ssh
```


# Generating keys
```shell
ssh-keygen -t ed25519 -a 100 -C '<your_email>'
```

This will generate a private key file `id_ed25519` and a public key file
`id_ed25519.pub` in the `~/.ssh/` directory using the Ed25519 elliptic curve
signature with 100 "rounds" and your email address as the "comment".

> **&#8505;&#65039;<!-- information emoji --> TIP:** Append your new public key
> into your `~/.ssh/allowed_signers` file (create the file if it doesn't exist).
> This allows your signature to be verified. Example `allowed_signers` file:
> ```
> <your_email> ssh-ed25519 AAA...
> ```


# Changing the private key password
```shell
ssh-keygen -p -a 100 -f ~/.ssh/id_ed25519
```


# Git
SSH can be used for both authenticating with remote repositories as well as
signing your commits and tags so that they can be verified. See
[Git#SSH](../git/README.md#ssh).
