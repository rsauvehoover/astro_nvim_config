# astro_nvim_config

Neovim config built on [AstroNvim](https://github.com/AstroNvim/AstroNvim) v6.
Lives at `~/.config/nvim`.

Part of a three-repo setup:

- [dotfiles](https://github.com/rsauvehoover/dotfiles): zsh, git, tmux,
  ghostty, Brewfile. Its `install.sh` installs neovim and clones this repo.
- astro_nvim_config (this repo): neovim.
- [claude-config](https://github.com/rsauvehoover/claude-config): Claude Code
  settings and memory.

## Install

Normally `~/working/dotfiles/install.sh` clones this into place. To do it by
hand, move any existing nvim state aside first:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
git clone git@github.com:rsauvehoover/astro_nvim_config.git ~/.config/nvim
```

Then start `nvim`. Lazy installs plugins on first launch; `lazy-lock.json`
pins their versions.
