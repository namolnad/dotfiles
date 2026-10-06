# frozen_string_literal: true

# Everything every machine gets. scripts/bootstrap runs `brew bundle` on it,
# which installs what's missing, upgrades what's outdated and adopts an app
# already in /Applications when it matches the cask.
#
# `trusted: true` records Homebrew's tap trust for a third-party package before
# bundle loads it, so a new machine needs no separate `brew trust`.

tap 'eddieantonio/eddieantonio'
tap 'namolnad/formulae'
tap 'nikitabobko/tap'

brew 'aria2'
brew 'bat'
brew 'blueutil'
brew 'chafa'
brew 'csvkit'
brew 'eddieantonio/eddieantonio/imgcat', trusted: true
brew 'exiftool'
brew 'eza'
brew 'fd'
brew 'ffmpeg-full', link: true # keg-only; linked so it's the ffmpeg on PATH
brew 'fzf'
brew 'gh'
brew 'git-delta'
brew 'go'
brew 'infisical'
brew 'lazygit'
brew 'lesspipe'
brew 'libpq', link: true
brew 'mas'
brew 'namolnad/formulae/display-arranger', trusted: true
brew 'namolnad/formulae/dotenvcrypt', trusted: true
brew 'namolnad/formulae/finch', trusted: true
# brew 'namolnad/formulae/jt', trusted: true
brew 'namolnad/formulae/local-well-known', trusted: true
brew 'neovim'
brew 'node'
brew 'postgresql@17'
brew 'powerlevel10k'
brew 'rbenv'
brew 'rbenv-default-gems'
brew 'ripgrep'
brew 'sd'
brew 'stow'
brew 'swiftformat'
brew 'tea'
brew 'the_silver_searcher'
brew 'tmux'
brew 'tree'
brew 'vips'
brew 'wget'
brew 'xcodegen'
brew 'yarn'
brew 'yazi'
brew 'zoxide'
brew 'zsh-autosuggestions'
brew 'zsh-syntax-highlighting'

# Language servers, formatters and linters that Neovim runs
brew 'delve'
brew 'eslint_d'
brew 'lua-language-server'
brew 'markdownlint-cli'
brew 'prettier'
brew 'prettierd'
brew 'stylua'
brew 'tree-sitter-cli'
brew 'typescript-language-server'

cask '1password'
cask '1password-cli'
cask 'alfred'
cask 'appcleaner'
# cask 'boop'
cask 'chatgpt'
cask 'cleanupbuddy'
cask 'dropbox'
cask 'font-hack-nerd-font'
cask 'font-meslo-lg-nerd-font'
cask 'gitup-app'
cask 'homerow'
cask 'karabiner-elements'
cask 'macpacker'
cask 'markedit'
cask 'ngrok'
cask 'nikitabobko/tap/aerospace', trusted: true
cask 'notion'
cask 'obsidian'
cask 'postico'
cask 'postman'
cask 'rocket'
cask 'textream'
cask 'vlc'
cask 'wezterm'
cask 'xcodes-app'
cask 'zoom'

mas 'AutoMute', id: 1_118_136_179
mas 'GIPHY CAPTURE', id: 668_208_984
# mas 'Magnet', id: 441_258_766
mas 'Pixelmator Pro', id: 1_289_583_905
mas 'Remote Desktop', id: 409_907_375
mas 'Simplefax', id: 1_165_017_252
mas 'Slack', id: 803_453_959
mas 'Vimari', id: 1_480_933_944
