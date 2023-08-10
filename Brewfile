$existing_apps = []

def app_exists?(app_name)
  exists = File.exist?("/Applications/#{app_name}.app")

  $existing_apps << app_name if exists

  exists
end

def mas_unless_exists(app_name, id:)
  return if app_exists?(app_name)
  mas app_name, id: id
end

# tap 'eddieantonio/eddieantonio' # Until imgcat works on M1

brew 'aria2'
brew 'bat'
brew 'exa'
brew 'fd'
brew 'fzf'
brew 'gh'
brew 'git-delta'
brew 'golang'
brew 'chafa' # brew 'imgcat' # not working on M1 Mac
brew 'mas'
brew 'rbenv'
brew 'rg'
brew 'sd'
brew 'the_silver_searcher'
brew 'vim'

tap 'homebrew/cask-fonts'
tap 'homebrew/cask'

cask 'alfred' unless app_exists?('Alfred 4')
cask 'appcleaner' unless app_exists?('AppCleaner')
cask 'dropbox' unless app_exists?('Dropbox')
cask 'font-hack-nerd-font' unless File.exist?("Library/Fonts/Hack Bold Nerd Font Complete.ttf")
cask 'gitup' unless app_exists?('GitUp')
cask 'iterm2' unless app_exists?('iTerm')
cask 'notion' unless app_exists?('Notion')
cask 'rocket' unless app_exists?('Rocket')
cask 'xcodes' unless app_exists?('Xcodes')

mas_unless_exists '1Password 7', id: 1333542190
mas_unless_exists 'AutoMute', id: 1118136179
mas_unless_exists 'GIPHY CAPTURE', id: 668208984
mas_unless_exists 'Magnet', id: 441258766
# mas_unless_exists 'Notability', id: 360593530
mas_unless_exists 'Pixelmator Pro', id: 1289583905
# mas_unless_exists 'Things3', id: 904280696

puts "App(s) already exist, install skipped: #{$existing_apps.join(', ')}\n" unless $existing_apps.empty?
