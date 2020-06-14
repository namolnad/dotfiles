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
brew 'hub'
brew 'imgcat'
brew 'mas'
brew 'pianobar'
brew 'rbenv'
brew 'rg'
brew 'swiftformat'
brew 'swiftlint'
brew 'the_silver_searcher'
brew 'tmux'
brew 'vim'

tap 'caskroom/fonts'
tap 'homebrew/cask'

cask 'alfred' unless app_exists?('Alfred 3')
cask 'appcleaner' unless app_exists?('AppCleaner')
cask 'bettertouchtool' unless app_exists?('BetterTouchTool')
cask 'charles' unless app_exists?('Charles')
cask 'docker' unless app_exists?('Docker')
cask 'dropbox' unless app_exists?('Dropbox')
cask 'flux' unless app_exists?('Flux')
cask 'font-hack-nerd-font' unless File.exist?("Library/Fonts/Hack Bold Nerd Font Complete.ttf")
cask 'gitup' unless app_exists?('GitUp')
cask 'iterm2' unless app_exists?('iTerm')
cask 'rocket' unless app_exists?('Rocket')
cask 'vanilla' unless app_exists?('Vanilla')
cask 'visual-studio-code' unless app_exists?('Visual Studio Code')

puts "App(s) already exist, install skipped: #{$existing_apps.join(', ')}\n" unless $existing_apps.empty?

mas '1Password 7', id: 1333542190
mas 'AutoMute', id: 1118136179
mas 'Bear', id: 1091189122
mas 'Contrast', id: 1254981365
mas 'GIPHY CAPTURE', id: 668208984
mas 'Markoff', id: 1084713122
mas 'Pixelmator', id: 407963104
mas 'Spark', id: 1176895641
mas 'Things3', id: 904280696
mas 'Xcode', id: 497799835 unless app_exists?('Xcode')
