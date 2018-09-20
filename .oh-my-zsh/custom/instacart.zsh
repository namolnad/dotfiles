#   ---------------------------
#   INSTACART
#   ---------------------------

export SUDO_USER='dan.loman'
export DEFAULT_COUNTRY_SLUG='US'
export DEFAULT_PBI_SLUG='instacart'

# General
alias vpn-disconnect="osascript -e 'tell application \"/Applications/Tunnelblick.app\"' -e 'disconnect \"Instacart\"' -e 'end tell'"
alias vpn-connect="osascript -e 'tell application \"/Applications/Tunnelblick.app\"' -e 'connect \"Instacart\"' -e 'end tell'"

# iOS
alias iconsumer="cd ~/Code/Instacart-ios;pwd"
alias iconsumer-exp="cd ~/Code/Experimental/Exp:instacart-ios"
alias reload_iconsumer="((killall Xcode || true); iconsumer; xed .)"
alias carthage_publish="AWS_PROFILE=default AWS_REGION='us-east-1' bundle exec carthage_cache publish -b instacart-ios-consumer-cache --trace"
alias carthage_force_install="AWS_PROFILE=default AWS_REGION='us-east-1' bundle exec carthage_cache install -b instacart-ios-consumer-cache --trace --force"

# Rails
alias instacart="cd ~/Code/Carrot/customers/instacart;pwd"
alias railss="cd ~/Code/Carrot/customers/instacart;pwd;myip;echo foreman run rails s -b 0.0.0.0;rails s -b 0.0.0.0"
alias monitor-deploy="while :; do echo && isc deploys all-customers --count 1 && echo && sleep 60; done"
# Rails (console)
alias railsc="cd ~/Code/Carrot/customers/instacart;pwd;echo foreman run rails console;foreman run rails console"
alias production_console="(instacart && script/console --country US --pbi instacart --server production)"
alias staging_console="(instacart && script/console --country US --pbi instacart --server console.staging)"
# Rails (db)
alias localsync="instacart;pgsync zones,warehouse_zones,regions,warehouses,delivery_hours,applicant_variants,applicant_experiments,postal_codes;pgsync users \"where email='dan.loman@instacart.com'\""
alias railsm="cd ~/Code/Carrot/migrations;pwd;echo bundle exec rake db:migrate;bundle exec rake db:migrate"
alias rs="psql -h sherlock.cwripsh2edcd.us-east-1.redshift.amazonaws.com -U danloman -d analytics -p 5439"

kill_old_server() {
  #!/bin/bash

  file="~/Code/Carrot/customers/instacarttmp/pids/server.pid"
  if [ -f $file ] ; then
    rm $file
  fi
  for PID in $(lsof -wni tcp:3000 | awk '/a/ {print $2 }');
    do kill -9 "$PID";
  done;
}
