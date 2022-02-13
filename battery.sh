#!/data/data/com.termux/files/usr/bin/bash
# The comments that starts with shellcheck is to configure shellcheck, ignore it.
nodepath="/sys/class/power_supply/battery";
default_nodepath="$nodepath";
design_capacity=4300;
config_enable_vooc=1;
config_voltage_unit="microvolt";
config_voltage_usb_unit="milivolt";
path_current="$nodepath/current_now";
path_voltage="$nodepath/voltage_now";
path_voltage_usb="$nodepath/../usb/device/ADC_Charger_Voltage";
path_capacity="$nodepath/capacity";
path_status="$nodepath/status";
path_temp="$nodepath/temp";
path_voocchg_ing="$nodepath/voocchg_ing";
path_fastcharger="$nodepath/fastcharger";
path_batt_fcc="$nodepath/batt_fcc";


# sanity check
if ! command -v termux-fix-shebang &>/dev/null; then
  echo "You are not using Termux, exiting";
  exit 1;
fi
if [ ! -f battery-utils.sh ]; then
  echo "battery-utils.sh not found, downloading";
  curl -s https://raw.githubusercontent.com/Hakimi0804/battery/master/battery-utils.sh -o battery-utils.sh;
fi
if [ ! -f battery.conf ]; then
  echo "Configuration file not found, using default configuration";
  sleep 2;
fi

# shellcheck source=battery-utils.sh
# shellcheck source=battery.conf
source battery-utils.sh 2>/dev/null;
source battery.conf 2>/dev/null;
new_nodepath="$nodepath";
# if the sourced config changed nodepath, we will need to reassign
# path_* variables
if [ "$default_nodepath" != "$new_nodepath" ]; then
  path_current="$new_nodepath/current_now";
  path_voltage="$new_nodepath/voltage_now";
  path_voltage_usb="$new_nodepath/../usb/device/ADC_Charger_Voltage";
  path_capacity="$new_nodepath/capacity";
  path_status="$new_nodepath/status";
  path_temp="$new_nodepath/temp";
  path_voocchg_ing="$new_nodepath/voocchg_ing";
  path_fastcharger="$new_nodepath/fastcharger";
  path_batt_fcc="$new_nodepath/batt_fcc";
fi

case $1 in
  -u | --update)
    updater
    exit $?
    ;;
  -c | --config)
    # shellcheck disable=SC2068,SC2048
    if [ "$#" -eq 4 ]; then
      config_handler "$2" "$3" "$4"
    elif [ "$#" -eq 3 ]; then
      config_handler "$2" "$3"
    else
      echo "${red}Invalid nummber of arguements: ${bold_white}$#";
      echo "Usage: battery.sh -c <action> <variable> [value]";
      echo "Example: battery.sh -c set enable_vooc 1";
      echo "Example: battery.sh -c unset voltage_unit milivolt";
      echo "Example: battery.sh -c get voltage_usb_unit${reset}";
      exit 1;
    fi
    exit $?
    ;;
  *)
    # do nothing
    ;;
esac

while true; do

  echo "${cyan}General Info";
  echo -e "${green}status  \t: ${bold_white}$status";
  echo -e "${green}capacity\t: ${bold_white}${capacity}%";
  echo -e "${green}current \t: ${bold_white}$current (${current//-/}mA)";

  if [ "$config_voltage_unit" = "microvolt" ]; then
    echo -e "${green}voltage \t: ${bold_white}${voltage}µV ($(bc -l <<< "$voltage / 1000" | sed 's/\..*//')mV)";
  else
    echo -e "${green}voltage \t: ${bold_white}${voltage}mV";
  fi

  if [ "$config_voltage_usb_unit" = "microvolt" ]; then
    echo -e "${green}USB voltage\t: ${bold_white}${voltage_usb}µV ($(bc -l <<< "$voltage_usb / 1000" | sed 's/\..*//')mV)";
  else
    echo -e "${green}USB voltage\t: ${bold_white}${voltage_usb}mV";
  fi

  echo -e "${green}wattage \t: ${bold_white}${wattage}W";
  echo -e "${green}USB wattage\t: ${bold_white}${wattage_usb}W";
  echo -e "${green}temp \t\t: ${bold_white}$(echo -e $temp | sed 's/\B[0-9]\{1\}\>/.&/')";

  if [[ $config_enable_vooc == 1 ]]; then
    echo -e "${green}voocchg_ing\t: ${bold_white}$voocchg_ing";
    echo -e "${green}fastcharger\t: ${bold_white}$fastcharger";
  fi

  echo;
  echo "${cyan}Health Info";
  echo -e "${green}Battery Health\t: ${bold_white}$batt_fcc/$design_capacity (${batt_fcc_percentage}%)";
  

  current=$(sudo cat $path_current);
  capacity=$(sudo cat $path_capacity);
  temp=$(sudo cat $path_temp);
  voltage=$(sudo cat $path_voltage);
  status=$(sudo cat $path_status);
  voltage_usb=$(sudo cat $path_voltage_usb);
  
  if [[ $config_enable_vooc == 1 ]]; then
    voocchg_ing=$(sudo cat $path_voocchg_ing);
    fastcharger=$(sudo cat $path_fastcharger);
  fi

  batt_fcc=$(sudo cat $path_batt_fcc);
  calc_wattage;
  calc_wattage usb;
  calc_bathealth;

  clear;

done
