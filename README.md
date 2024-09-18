# OMF2

> Manage plugin packs for the Fish shell

## Note

**This project is in early stages... more to come soon!**

## Install

First, install [Fisher][fisher]. OMF2 uses Fisher to manage your plugin packs, so if you are already a Fisher user you'll feel right at home.

Once you have Fisher installed, you can install the `omf2` and the core plugin pack with Fisher:

```fish
fisher install omf2/plugins-core
```

Alternatively, if you have developed your own plugins pack, you can install the OMF2 utility as a standalone to manage it:

```fish
fisher install omf2/omf2
```

## Usage

See which plugins are available with the 'list' command:

```fish
> omf2 list
bang-commands
brew
colorize-man-pages
directory
extract
gitignore
macos
magic-enter
up
zoxide
...
```

To enable a plugin, use the 'enable' command.

```fish
omf2 enable zoxide
```

Similarly, to disable a plugin, use the 'disable' command.

```fish
omf2 disable colorize-man-pages
```

OMF2 uses [Fisher][fisher] to manage its plugin packs, updating your plugin packs is all done the same way you update your other plugins:

```fish
fisher update
```

Similarly, to uninstall OMF2, disable all your plugin packs and uninstall:

```fish
omf2 disable --all
fisher remove omf2/omf2
```

## Attributions

- [Logo][logo] by <a href="https://www.svgrepo.com" target="_blank">SVG Repo</a>


[fisher]: https://github.com/jorgebucaran/fisher
[logo]: https://www.svgrepo.com/svg/156874/fish
