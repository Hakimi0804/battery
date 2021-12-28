#!/data/data/com.termux/files/usr/bin/bash
# Most of these useless comment lines are for github copilot
# (and the one that starts with shellheck is for shellcheck ovbiously)
nodepath="/sys/class/power_supply/battery";
design_capacity=4300;
config_enable_vooc=1;
config_voltage_unit="microvolt";
path_current="$nodepath/current_now";
path_voltage="$nodepath/voltage_now";
path_capacity="$nodepath/capacity";
path_status="$nodepath/status";
path_temp="$nodepath/temp";
path_voocchg_ing="$nodepath/voocchg_ing";
path_fastcharger="$nodepath/fastcharger";


# if utils doesn't exist, wattage will not be calculated
if [ ! -f battery-utils.sh ]; then
  echo "battery-utils.sh not found, downloading";
  wget -q https://raw.githubusercontent.com/Hakimi0804/battery/master/battery-utils.sh;
fi
if [ ! -f battery.conf ]; then
  echo "Configuration file not found, using default configuration";
  sleep 2;
fi

# shellcheck source=battery-utils.sh
# shellcheck source=battery.conf
source battery-utils.sh 2>/dev/null;
source battery.conf 2>/dev/null;

while true; do

  echo "${cyan}General Info";
  echo "${green}status: ${bold_white}$status";
  echo "${green}capacity: ${bold_white}${capacity}%";
  echo "${green}current: ${bold_white}$current ($(echo "$current" | sed 's/-//')mA)";
  echo "${green}voltage: ${bold_white}${voltage}mV";
  echo "${green}wattage: ${bold_white}${wattage}W";
  echo "${green}temp: ${bold_white}$(echo $temp | sed 's/\B[0-9]\{1\}\>/.&/')";

  if [[ $config_enable_vooc == 1 ]]; then
    echo "${green}voocchg_ing: ${bold_white}$voocchg_ing";
    echo "${green}fastcharger: ${bold_white}$fastcharger";
  fi

  echo;
  echo "${cyan}Health Info";
  echo "${green}Battery Health: ${bold_white}$batt_fcc/$design_capacity (${batt_fcc_percentage}%)";
  

  current=$(sudo cat $path_current);
  capacity=$(sudo cat $path_capacity);
  temp=$(sudo cat $path_temp);
  voltage=$(sudo cat $path_voltage);
  status=$(sudo cat $path_status);
  
  if [[ $config_enable_vooc == 1 ]]; then
    voocchg_ing=$(sudo cat $path_voocchg_ing);
    fastcharger=$(sudo cat $path_fastcharger);
  fi

  batt_fcc=$(sudo cat $nodepath/batt_fcc);
  calc_wattage;
  calc_bathealth;

  clear;

done
