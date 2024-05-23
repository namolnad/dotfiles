# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
$existing_apps = []

def app_exists?(app_name)
  exists = File.exist?("/Applications/#{app_name}.app")

  $existing_apps << app_name if exists

  exists
end

def mas_unless_exists(app_name, id:)
  return if app_exists?(app_name)

  mas app_name, id:
end

brew 'aria2'
brew 'bat'
brew 'blueutil'
brew 'eddieantonio/eddieantonio/imgcat'
brew 'eza'
brew 'fd'
brew 'fzf'
brew 'gh'
brew 'git-delta'
brew 'golang'
brew 'mas'
brew 'powerlevel10k'
brew 'rbenv'
brew 'rg'
brew 'sd'
brew 'the_silver_searcher'
brew 'tmux'
brew 'tree'
brew 'nvim'
brew 'zsh-autosuggestions'
brew 'zsh-syntax-highlighting'
brew 'zoxide'

tap 'homebrew/cask'

cask 'alacritty' unless app_exists?('Alacritty')
cask 'alfred' unless app_exists?('Alfred 4')
cask 'appcleaner' unless app_exists?('AppCleaner')
cask 'dropbox' unless app_exists?('Dropbox')
cask 'font-meslo-lg-nerd-font' unless File.exist?('Library/Fonts/MesloLGS NF Regular.ttf')
cask 'font-hack-nerd-font' unless File.exist?('Library/Fonts/Hack Bold Nerd Font Complete.ttf')
cask 'gitup' unless app_exists?('GitUp')
cask 'iterm2' unless app_exists?('iTerm')
cask 'notion' unless app_exists?('Notion')
cask 'rocket' unless app_exists?('Rocket')
cask 'xcodes' unless app_exists?('Xcodes')

mas_unless_exists '1Password', id: 443_987_910 # Unsure if this is the right ID for v8
mas_unless_exists 'AutoMute', id: 1_118_136_179
mas_unless_exists 'GIPHY CAPTURE', id: 668_208_984
mas_unless_exists 'Magnet', id: 441_258_766
mas_unless_exists 'Pixelmator Pro', id: 1_289_583_905
mas_unless_exists 'BetterTouchTool', id: 428_937_561 # Unsure if this is the right ID

puts "App(s) already exist, install skipped: #{$existing_apps.join(', ')}\n" unless $existing_apps.empty?
# rubocop:enable Style/GlobalVars
