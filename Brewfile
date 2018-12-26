$existing_apps = []

def app_exists?(app_name)
  exists = File.exist?("/Applications/#{app_name}.app")

  $existing_apps << app_name if exists

  exists
end

brew 'rbenv'
brew 'bat'
brew 'hub'
tap 'homebrew/cask'
tap 'caskroom/fonts'
cask 'font-hack-nerd-font'
cask 'gitup' unless app_exists?('GitUp')
cask 'iterm2' unless app_exists?('iTerm')
cask 'alfred' unless app_exists?('Alfred 3')
cask 'visual-studio-code' unless app_exists?('Visual Studio Code')

puts "App(s) already exist, install skipped: #{$existing_apps.join(', ')}\n" unless $existing_apps.empty?
