# oh-my-fish-2

> The next generation Fish shell framework

Helping users of Oh-My-Zsh and legacy Oh-My-Fish feel at home in the Fish shell.

## NOT YET!

**This project is in early-alpha stages... give it some time... more to come soon!**

## Install

First, install [Fisher][fisher].

Next, install the `omf2` utility along with the core plugins package:

```fish
fisher install oh-my-fish-2/plugins-core
```

## Usage

See which plugins are available:

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
```

To enable or disable a plugin, use the appropriate command.

```fish
omf2 enable zoxide
omf2 disable up
```

Oh-My-Fish-2 uses Fisher for plugin management, so to update plugins, simply run:

```fish
fisher update
```

## Attributions

- [Logo][logo] by <a href="https://www.svgrepo.com" target="_blank">SVG Repo</a>


[fisher]: https://github.com/jorgebucaran/fisher
[logo]: https://www.svgrepo.com/svg/156874/fish
