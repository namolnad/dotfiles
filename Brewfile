# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
$existing_apps = []

def app_exists?(app_name)
  exists = File.exist?("/Applications/#{app_name}.app")

  $existing_apps << app_name if exists

  exists
end

def cask_unless_exists(brew_name, name:)
  return if app_exists?(name)

  cask brew_name
end

def mas_unless_exists(app_name, id:)
  return if app_exists?(app_name)

  mas app_name, id:
end

brew 'aria2'
brew 'bat'
brew 'blueutil'
brew 'chafa'
brew 'csvkit'
brew 'eddieantonio/eddieantonio/imgcat'
brew 'exiftool'
brew 'eza'
brew 'fd'
brew 'fzf'
brew 'gh'
brew 'git-delta'
brew 'golang'
brew 'lesspipe'
brew 'mas'
brew 'postgresql@16'
brew 'powerlevel10k'
brew 'rbenv'
brew 'rg'
brew 'sd'
brew 'stow'
brew 'the_silver_searcher'
brew 'tmux'
brew 'tree'
brew 'nvim'
brew 'wget'
brew 'xsv'
brew 'yazi'
brew 'zsh-autosuggestions'
brew 'zsh-completions', args: ['head']
brew 'zsh-syntax-highlighting'
brew 'zoxide'

tap 'homebrew/cask'

cask 'font-meslo-lg-nerd-font' unless File.exist?('Library/Fonts/MesloLGS NF Regular.ttf')
cask 'font-hack-nerd-font' unless File.exist?('Library/Fonts/Hack Bold Nerd Font Complete.ttf')

cask_unless_exists '1password', name: '1Password'
cask_unless_exists 'nikitabobko/tap/aerospace', name: 'Aerospace'
cask_unless_exists 'alacritty', name: 'Alacritty'
cask_unless_exists 'alfred', name: 'Alfred 5'
cask_unless_exists 'appcleaner', name: 'AppCleaner'
cask_unless_exists 'boop', name: 'Boop'
cask_unless_exists 'chatgpt', name: 'ChatGPT'
cask_unless_exists 'cleanupbuddy', name: 'CleanupBuddy'
cask_unless_exists 'dropbox', name: 'Dropbox'
cask_unless_exists 'gitup', name: 'GitUp'
cask_unless_exists 'notion', name: 'Notion'
cask_unless_exists 'obsidian', name: 'Obsidian'
cask_unless_exists 'postico', name: 'Postico 2'
cask_unless_exists 'postman', name: 'Postman'
cask_unless_exists 'rocket', name: 'Rocket'
cask_unless_exists 'slack', name: 'Slack'
cask_unless_exists 'vlc', name: 'VLC'
cask_unless_exists 'wezterm', name: 'WezTerm'
cask_unless_exists 'xcodes', name: 'Xcodes'
cask_unless_exists 'zoom', name: 'Zoom'

mas_unless_exists 'AutoMute', id: 1_118_136_179
mas_unless_exists 'GIPHY CAPTURE', id: 668_208_984
mas_unless_exists 'Magnet', id: 441_258_766
mas_unless_exists 'Pixelmator Pro', id: 1_289_583_905
mas_unless_exists 'Simplefax', id: 1_165_017_252
mas_unless_exists 'Vimari', id: 1_480_933_944

puts "App(s) already exist, install skipped: #{$existing_apps.join(', ')}\n" unless $existing_apps.empty?
# rubocop:enable Style/GlobalVars
