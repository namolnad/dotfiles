#   ---------------------------
#   INSTACART
#   ---------------------------

alias ishopper="cd ~/code/instashopper-ios;pwd"
alias ashopper="cd ~/code/instashopper-android;pwd"
alias iconsumer="cd ~/code/instacart-ios;pwd"
alias instacart="cd ~/code/carrot/customers/instacart;pwd"
alias railss="cd ~/code/carrot/customers/instacart;pwd;myip;echo foreman run rails s -b 0.0.0.0;foreman run rails s -b 0.0.0.0"
alias shoppers="cd ~/code/carrot/shoppers/shopper-api;pwd;myip;echo bundle exec rails server -b 0.0.0.0 -p 5000;bundle exec rails server -b 0.0.0.0 -p 5000"
alias railsc="cd ~/code/carrot/customers/instacart;pwd;echo foreman run rails console;foreman run rails console"
alias railsm="cd ~/code/carrot/migrations;pwd;echo bundle exec rake db:migrate;bundle exec rake db:migrate"
alias clipscript="cat ~/code/dans-scripts/work/isc-scripts.rb | pbcopy"
alias localsync="instacart;pgsync zones,warehouse_zones,regions,warehouses,delivery_hours,applicant_variants,applicant_experiments,postal_codes;pgsync users \"where email='dan.loman@instacart.com'\""
alias identity-permission-fix="ssh-add -A"
alias rs="psql -h sherlock.cwripsh2edcd.us-east-1.redshift.amazonaws.com -U danloman -d analytics -p 5439"
alias carthage_publish="AWS_PROFILE=default AWS_REGION="us-east-1" bundle exec carthage_cache publish -b instacart-ios-consumer-cache --trace"
alias carthage_force_install="AWS_PROFILE=default AWS_REGION="us-east-1" bundle exec carthage_cache install -b instacart-ios-consumer-cache --trace --force"
alias production_console="(instacart && script/console --country US --pbi instacart --server production)"
alias staging_console="(instacart && script/console --country US --pbi instacart --server console.staging)"
alias vpn-connect="osascript -e 'tell application \"/Applications/Tunnelblick.app\"' -e 'connect \"Instacart\"' -e 'end tell'"
alias vpn-disconnect="osascript -e 'tell application \"/Applications/Tunnelblick.app\"' -e 'disconnect \"Instacart\"' -e 'end tell'"
alias reload_iconsumer="(killall Xcode || true) && iconsumer && open Instacart.xcodeproj"
alias monitor-deploy="while :; do echo && isc deploys all-customers --count 1 && echo && sleep 60; done"
alias console-staging="(instacart; script/console --country US --pbi instacart --server console.instacart.customers-stg)"
alias console-prod="(instacart; script/console --country US --pbi instacart --server console.instacart.customers)"

kill_old_server() {
  #!/bin/bash

  file="~/Code/carrot/customers/instacarttmp/pids/server.pid"
  if [ -f $file ] ; then
    rm $file
  fi
  for PID in $(lsof -wni tcp:3000 | awk '/a/ {print $2 }');
    do kill -9 "$PID";
  done;
}
