# Itzi's Dotfiles

Contains my dotfiles for:

- [Dunst](https://dunst-project.org/)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [Neovim](https://neovim.io/)
- [Vim](https://github.com/vim/vim)
- [Zsh](https://www.zsh.org/)
- [XMonad](https://xmonad.org/)
  - [Polybar](https://polybar.github.io/)
  - [Picom](https://wiki.archlinux.org/index.php/Picom)
- [Zathura](https://pwmt.org/projects/zathura/)

## Usage

Download and type:

```sh
stow neovim
```

For example, if you want to use the stable neovim configuration.

## HiDPI

There are 2 different setups for XMonad, one for HiDPI and another for normal DPI screen. 
This is done due to having different configurations for each DPI (such as rofi dpi, polybar size, etc. ).

## External Dependencies

- [zplug/zplug](https://github.com/zplug/zplug): Managing zsh dependencies
- [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim): Nvim plugins
- [kristijanhusak/vim-packager](https://github.com/kristijanhusak/vim-packager): Vim plugins
