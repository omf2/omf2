# OMF2

> Manage plugin packs for the Fish shell

## Note

**This project is in early stages... more to come soon!**

## Install

First, install [Fisher][fisher]. OMF2 uses Fisher to manage your plugin packs, so if you are already a Fisher user you'll feel right at home.

Once you have Fisher installed, you can install `omf2` and the core plugin pack with Fisher:

```console
fisher install omf2/core-plugins-pack
```

The [omf2/core-plugins-pack][core-plugins-pack] you just installed is called an OMF2 "plugin pack". Plugin packs will install the OMF2 utility for you. Alternatively, if you just want OMF2 as a standalone utility, you can simply run:

```console
fisher install omf2/omf2
```

OMF2 can also work with your own custom plugin packs. To install a different plugin pack, again use Fisher:

```console
fisher install your-name/your-omf2-plugin-pack
```

## Usage

See which plugins are available with the 'list' command:

```console
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

```console
omf2 enable zoxide
```

Similarly, to disable a plugin, use the 'disable' command.

```console
omf2 disable colorize-man-pages
```

OMF2 uses [Fisher][fisher] to manage its plugin packs. That means updating your OMF2 plugin packs is as simple as running:

```console
fisher update
```

Similarly, to uninstall OMF2, all you need to do is disable all your plugin packs, and then use Fisher's uninstall:

```console
omf2 disable --all
fisher remove omf2/omf2
```

## Oh-My-Fish / Oh-My-Zsh users

Are you a user of Oh-My-Zsh or Oh-My-Fish? Plugin packs with OMF2 alternatives are in development! Stay tuned.

## Want to develop your own plugin pack?

Stay tuned! More details to come soon.

## Attributions

- [Logo][logo] by <a href="https://www.svgrepo.com" target="_blank">SVG Repo</a>


[core-plugins-pack]: https://github.com/omf2/core-plugins-pack
[fisher]: https://github.com/jorgebucaran/fisher
[logo]: https://www.svgrepo.com/svg/156874/fish
