#!/bin/false 
# shellcheck shell=bash

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
  voltage_1=$(bc -l <<< "$voltage / 1000");
  pre_wattage=$(bc -l <<< "$current_1 * $voltage_1");
  wattage=$(round $pre_wattage 2);
}

calc_bathealth() {
  pre_batt_fcc_percentage=$(bc -l <<< "$batt_fcc / $design_capacity * 100");
  batt_fcc_percentage=$(round $pre_batt_fcc_percentage 2);
}
