$existing_apps = []

def app_exists?(app_name)
  exists = File.exist?("/Applications/#{app_name}.app")

  $existing_apps << app_name if exists

  exists
end

brew 'mas'
brew 'vim', args: ['with-override-system-vi']
brew 'rbenv'
brew 'bat'
brew 'hub'
brew 'the_silver_searcher'
tap 'homebrew/cask'
tap 'caskroom/fonts'
cask 'font-hack-nerd-font'
cask 'gitup' unless app_exists?('GitUp')
cask 'iterm2' unless app_exists?('iTerm')
cask 'alfred' unless app_exists?('Alfred 3')
cask 'visual-studio-code' unless app_exists?('Visual Studio Code')

puts "App(s) already exist, install skipped: #{$existing_apps.join(', ')}\n" unless $existing_apps.empty?

mas 'GIPHY CAPTURE', id: 668208984
mas 'Things3', id: 904280696
mas 'Pixelmator', id: 407963104
mas 'AutoMute', id: 1118136179
mas 'BetterSnapTool', id: 417375580
mas 'Spark', id: 1176895641
mas '1Password 7', id: 1333542190
# mas 'Xcode', id: 497799835
