#!/bin/bash
COIN_PATH=$(dirname "$0")/../
PWD=$(pwd)

print_help() {
    echo "This is Cortez Shitcoin Generator"
    echo 'Copyright (c) 1994-2022 AltcoinBaggins and mdfkbtc'
    echo 'Report bugs to your grandmother.'
    echo ''
    echo 'Usage: shtool <command>'
    echo ''
    echo 'Available global <command>s:'
#   echo '  -v, --version   display shtool version information'
    echo '  -h, --help      display shtool usage help page (this one)'
#   echo '  -d, --debug     display shell trace information'
    echo '  -a, --all       update all variables'
    echo '  -b, --base      update only base variables, no URLs'
    echo '  -u, --all       update only URL variables'
    echo ''
}

if [ $# -eq 0 ]; then
    echo "$0:Error: invalid command line" 1>&2
    print_help
    exit 1
fi
if [ ".$1" = ".-h" ] || [ ".$1" = ".--help" ]; then
    print_help
    exit 0
fi

## Load configuration
source "${COIN_PATH}/fork/fork.conf"

# Calculate more config variables
COIN_NAME_LOW="${COIN_NAME,,}"

## Do replacements
cd "${COIN_PATH}"

if [ ".$1" != ".-b" ] && [ ".$1" != ".--base" ]; then
    GITHUB_REPO_REPL=$(echo $GITHUB_REPO | sed 's/\//\\\//g')
    find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/cortez-project\/cortez/${GITHUB_REPO_REPL}/g" {} +
    DISCORD_URL_REPL=$(echo $DISCORD_URL | sed 's/\//\\\//g')
    find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/https:\/\/discord\.gg\/RpBXAnvp7k/${DISCORD_URL_REPL}/g" {} +
    find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/cortezcoin\.com/${COIN_WEBSITE}/g" {} +
fi

if [ ".$1" = ".-u" ] || [ ".$1" = ".--url" ]; then
    exit 0
fi

find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/CRTZ/${COIN_TICKER}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/Cortez/${COIN_NAME}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/cortez/${COIN_NAME_LOW}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/9991/${P2P_PORT}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/9992/${RPC_PORT}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/000006564484/${TOTAL_SUPPLY}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/111116564484/${PREMINE}/g" {} +

## Rename files
# Repeat to make sure it works recursively, TODO: use better loop
for i in {0..6}
do
  find . -name "*" -not -path "./.git/*" | grep 'Cortez' | xargs -I {} sh -c 'git mv "{}" "$(echo {} | sed 's/Cortez/${COIN_NAME}/g')"'
  find . -name "*" -not -path "./.git/*" | grep 'cortez' | xargs -I {} sh -c 'git mv "{}" "$(echo {} | sed 's/cortez/${COIN_NAME_LOW}/g')"'
done

# Come back where we were
cd $PWD
