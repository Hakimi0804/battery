#!/bin/false 
# ^~~~~~~~~ to be fixed by termux-fix-shebang
# shellcheck shell=bash
# this file will be sourced by the main script (bruh.sh)
# shellcheck source=bruh.sh
# make a function that rounds a float (e.g 1.5) to the nearest integer
# (e.g. 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
round() {
  echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc));
}

# colours
cyan=$(tput setaf 6)
green=$(tput setaf 2)
red=$(tput setaf 1)
bold_white=$(tput bold; tput setaf 7)
reset=$(tput sgr 0)


calc_wattage() {
  local current=${current//-/};
  current_1=$(bc -l <<< "$current / 1000");
  voltage_1=$(bc -l <<< "$voltage / 1000");
  pre_wattage=$(bc -l <<< "$current_1 * $voltage_1");
  wattage=$(round $pre_wattage 2);
}

calc_bathealth() {
  pre_batt_fcc_percentage=$(bc -l <<< "$batt_fcc / $design_capacity * 100");
  batt_fcc_percentage=$(round $pre_batt_fcc_percentage 2);
}
