#!/usr/bin/env bash

set -u

app_id="${1:?usage: toggle-btop.sh APP_ID CONFIG_PATH}"
config_path="${2:?usage: toggle-btop.sh APP_ID CONFIG_PATH}"

address="$({ hyprctl clients -j 2>/dev/null || printf '[]'; } |
  jq -r --arg app_id "$app_id" \
    '[.[] | select(.class == $app_id)][0].address // empty')"

if [[ -n "$address" ]]; then
  exec hyprctl dispatch \
    "hl.dsp.window.close({ window = \"address:$address\" })"
fi

exec omarchy-launch-or-focus-tui \
  "--app-id=$app_id" btop --config "$config_path"
