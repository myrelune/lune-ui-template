DIR="$(cd "$(dirname "$0")" && pwd)"
"$DIR/darklua" process ./src/init.lua dist/main.lua