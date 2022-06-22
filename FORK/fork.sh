#!/bin/bash
COIN_PATH=$(dirname "$0")/../
PWD=$(pwd)

print_help() {
    echo "This is LapisLazuli Shitcoin Generator"
    echo 'Copyright (c) 1994-2022 AltcoinBaggins and mdfkbtc'
    echo 'Report bugs to your grandmother.'
    echo ''
    echo 'Usage: '$( basename "${0}" )" <command>"
    echo ''
    echo 'Available global <command>s:'
#   echo '  -v, --version   display version information'
    echo '  -h, --help      display usage help page (this one)'
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
source "${COIN_PATH}/FORK/fork.conf"

# Calculate more config variables
COIN_NAME_LOW="${COIN_NAME,,}"

## Do replacements
cd "${COIN_PATH}"

if [ ".$1" != ".-b" ] && [ ".$1" != ".--base" ]; then
    GITHUB_REPO_REPL=$(echo $GITHUB_REPO | sed 's/\//\\\//g')
    find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/lapislazuli-project\/lapislazuli/${GITHUB_REPO_REPL}/g" {} +
    DISCORD_URL_REPL=$(echo $DISCORD_URL | sed 's/\//\\\//g')
    find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/https:\/\/discord\.gg\/RpBXAnvp7k/${DISCORD_URL_REPL}/g" {} +
    find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/lapislazulicoin\.com/${COIN_WEBSITE}/g" {} +
fi

if [ ".$1" = ".-u" ] || [ ".$1" = ".--url" ]; then
    exit 0
fi

find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/LiLLi/${COIN_TICKER}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/LapisLazuli/${COIN_NAME}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -exec sed -i "s/lapislazuli/${COIN_NAME_LOW}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -not -path "./src/crypto" -exec sed -i "s/19330/${P2P_PORT}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -not -path "./src/crypto" -exec sed -i "s/19660/${RPC_PORT}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -not -path "./src/crypto" -exec sed -i "s/10000000000/${TOTAL_SUPPLY}/g" {} +
find . -type f -iname '*' -not -path "./.git/*" -not -path "./src/crypto" -exec sed -i "s/15500000/${PREMINE}/g" {} +

## Rename files
# Repeat to make sure it works recursively, TODO: use better loop
for i in {0..6}
do
  find . -name "*" -not -path "./.git/*" | grep 'LapisLazuli' | xargs -I {} sh -c 'git mv "{}" "$(echo {} | sed 's/LapisLazuli/${COIN_NAME}/g')"'
  find . -name "*" -not -path "./.git/*" | grep 'lapislazuli' | xargs -I {} sh -c 'git mv "{}" "$(echo {} | sed 's/lapislazuli/${COIN_NAME_LOW}/g')"'
done

# Come back where we were
cd $PWD
