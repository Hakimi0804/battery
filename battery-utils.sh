#!/data/data/com.termux/files/usr/bin/false
# shellcheck shell=bash

# make sure required commands exist. if not, install them
required_commands=( sudo tput bc wget );
for command in "${required_commands[@]}"; do
  if ! command -v "$command" &>/dev/null; then
    req_cmd_err=1;
  fi
done

if [ "$req_cmd_err" -eq 1 ]; then
  echo "Required commands not found, installing...";
  pkg install -y tsu ncurses-utils wget bc &>/dev/null;
fi

# colours
cyan=$(tput setaf 6)
green=$(tput setaf 2)
red=$(tput setaf 1)
bold_white=$(tput bold; tput setaf 7)
reset=$(tput sgr 0)

round() {
  # round function made by github copilot
  # usage: round <number> <decimal places>
  # example: round 1.2345 2
  # returns: 1.23
  echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc));
}

calc_wattage() {
  local current=${current//-/};
  current_1=$(bc -l <<< "$current / 1000");

  if [ "$1" = "usb" ]; then
    local voltage=$voltage_usb;
    local usb=true
  fi

  if [ "$usb" = "true" ]; then
    if [ "$config_voltage_usb_unit" = "microvolt" ]; then
      local config_voltage_unit="microvolt"
    else
      local config_voltage_unit="milivolt"
    fi
  fi

  if [ "$config_voltage_unit" = "microvolt" ]; then
    voltage_1=$(bc -l <<< "$voltage / 1000000");
  else
    voltage_1=$(bc -l <<< "$voltage / 1000");
  fi

  pre_wattage=$(bc -l <<< "$current_1 * $voltage_1");

  if [ "$1" = "usb" ]; then
    wattage_usb=$(round "$pre_wattage" 2);
  else
    wattage=$(round "$pre_wattage" 2);
  fi

}

calc_bathealth() {
  pre_batt_fcc_percentage=$(bc -l <<< "$batt_fcc / $design_capacity * 100");
  batt_fcc_percentage=$(round $pre_batt_fcc_percentage 2);
}

updater() {
  echo "${cyan}Updating battery-utils.sh...";
  wget https://raw.githubusercontent.com/Hakimi0804/battery/master/battery-utils.sh -qO battery-utils.sh || update_err=1;
  echo "Updating battery.sh...";
  wget https://raw.githubusercontent.com/Hakimi0804/battery/master/battery.sh -qO battery.sh || update_err=1;
  if [ "$update_err" = "1" ]; then
    echo "${red}Update failed, please try again later.";
    return 1;
  else
    echo "${green}Update complete. Please run battery.sh again.";
    return 0;
  fi
}

config_handler() {
  action="$1";
  variable="$2";
  value="$3";

  # we store the config in a file called battery.conf
  # actions: set, unset, get
  case "$action" in
    set)
      if [ "$#" -eq 3 ]; then
      # remove existing config line if it exists
        sed -i "/^$variable/d" battery.conf;
        # sed -i 's/\n//g' battery.conf;
        echo "$variable=$value" >> battery.conf;
        return $?;
      else
        return 1;
      fi
      ;;

    unset)
      if [ "$#" -eq 2 ]; then
        sed -i "/$variable/d" battery.conf;
        # sed -i 's/\n//g' battery.conf;
        return $?;
      else
        return 1;
      fi
      ;;

    get)
      if [ "$#" -eq 2 ]; then
        grep "$variable" battery.conf;
        return $?;
      else
        return 1;
      fi
      ;;

    *)
      echo "Invalid action.";
      return 1;
      ;;
  esac
}
