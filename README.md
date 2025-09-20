# recovery-installer

---

This project is intended to create an external recovery device with an Arch Linux and a NixOS installation.
My aim is to make it work in both a NixOS live ISO or an Arch Linux one.
I'll be using [Tokland's Arch-bootstrap](https://github.com/tokland/arch-bootstrap) to get pacman working in NixOS ISOs and [archinstall](https://github.com/archlinux/archinstall) + [AUR plugin](https://github.com/torxed/archinstall-aur) to install Arch from a custom preset.
NixOS will be installed using it's own custom flake.

This tool is intended for personal use and most installation configurations are hardcoded, feel free to change them to your own needs.


> [!WARNING]
> This is a huge WIP and I don't recommend anyone to test it at this stage as it could kill a hard drive if used wrong.

---

### To-do:
- [] Add [decman](https://github.com/kiviktnm/decman) declarative Arch config
- [] Create a NixOS installation script
- [] Write documentation
- [] Test tons...
