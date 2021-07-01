$existing_apps = []

def app_exists?(app_name)
  exists = File.exist?("/Applications/#{app_name}.app")

  $existing_apps << app_name if exists

  exists
end

tap 'eddieantonio/eddieantonio'

brew 'aria2'
brew 'bat'
brew 'fasd'
brew 'fzf'
brew 'gh'
brew 'git-delta'
brew 'golang'
brew 'imgcat'
brew 'mas'
brew 'rbenv'
brew 'rg'
brew 'the_silver_searcher'
brew 'vim'

tap 'homebrew/cask-fonts'
tap 'homebrew/cask'

cask 'alfred' unless app_exists?('Alfred 4')
cask 'appcleaner' unless app_exists?('AppCleaner')
cask 'bettertouchtool' unless app_exists?('BetterTouchTool')
cask 'dropbox' unless app_exists?('Dropbox')
cask 'font-hack-nerd-font' unless File.exist?("Library/Fonts/Hack Bold Nerd Font Complete.ttf")
cask 'gitup' unless app_exists?('GitUp')
cask 'iterm2' unless app_exists?('iTerm')
cask 'rocket' unless app_exists?('Rocket')

puts "App(s) already exist, install skipped: #{$existing_apps.join(', ')}\n" unless $existing_apps.empty?

mas '1Password 7', id: 1333542190 unless app_exists?('1Password 7')
mas 'AutoMute', id: 1118136179
mas 'GIPHY CAPTURE', id: 668208984
mas 'Pixelmator', id: 407963104
mas 'Things3', id: 904280696
mas 'Xcode', id: 497799835 unless app_exists?('Xcode')
