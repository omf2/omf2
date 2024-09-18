# OMF2

> Manage plugin packs for the Fish shell

## Note

**This project is in early, experimental stages... more to come!**

It works, and bug reports/PRs are welcome.

## Description

OMF2 hosts collections of Fish shell scripts called "plugin packs". Plugin Packs allow you build and share groups a Fish plugins easier. OMF2 aims to make it easy to find, use, share, borrow, and adapt Fish scripts and make them your own. It also aims to make transitioning to Fish easier for users of other shell frameworks, like [Oh-My-Zsh][omz].

This repo hosts the `omf2` utility. It is a small, dirt simple Fish plugin pack manager that leverages the popular [Fisher][fisher] plugin manager to support its plugin packs.

## Install

First, follow the installation instructions to install [Fisher][fisher]. OMF2 requires Fisher, so if you are already a Fisher user you'll feel right at home. If you haven't used Fisher, its job is to manage standalone Fish plugins. OMF2 leverages Fisher's capabilities to add support for "Plugin Packs", which are collections of nested plugins within a single repo.

Once you have Fisher installed, you can install the `omf2` utility and the core plugin pack with Fisher:

```console
fisher install omf2/core-plugins-pack
```

Installing a plugin pack like [omf2/core-plugins-pack][core-plugins-pack] will install the OMF2 utility for you. Alternatively, if you just want OMF2 as a standalone utility, you can simply run:

```console
fisher install omf2/omf2
```

OMF2 can also work with your own custom plugin packs. To install a different plugin pack, again simply use Fisher:

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


[omz]: https://github.com/ohmyzsh/ohmyzsh
[core-plugins-pack]: https://github.com/omf2/core-plugins-pack
[fisher]: https://github.com/jorgebucaran/fisher
[logo]: https://www.svgrepo.com/svg/156874/fish
