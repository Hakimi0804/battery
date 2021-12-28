#!/bin/false 
# shellcheck shell=bash

# make sure required commands exist. if not, install them
required_commands=( tput bc wget );
for command in "${required_commands[@]}"; do
  if ! command -v "$command" >/dev/null 2>&1; then
    req_cmd_err=1;
  fi
done

if [ "$req_cmd_err" -eq 1 ]; then
  echo "Required commands not found, installing...";
  pkg install -y ncurses-utils wget bc &>/dev/null;
fi

# colours
cyan=$(tput setaf 6)
green=$(tput setaf 2)
red=$(tput setaf 1)
bold_white=$(tput bold; tput setaf 7)
reset=$(tput sgr 0)

round() {
  echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc));
}

calc_wattage() {
  local current=${current//-/};
  current_1=$(bc -l <<< "$current / 1000");

  if [ "$config_voltage_unit" = "microvolt" ]; then
    voltage_1=$(bc -l <<< "$voltage / 1000000");
  else
    voltage_1=$(bc -l <<< "$voltage / 1000");
  fi

  pre_wattage=$(bc -l <<< "$current_1 * $voltage_1");
  wattage=$(round $pre_wattage 2);
}

calc_bathealth() {
  pre_batt_fcc_percentage=$(bc -l <<< "$batt_fcc / $design_capacity * 100");
  batt_fcc_percentage=$(round $pre_batt_fcc_percentage 2);
}
