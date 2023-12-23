# BATTERY
Was gonna keep this private but someone requested it 🤷‍♂️ sooo
don't complain about it being stupid or anything.
However issues are welcome.

## CONVENIENCE
Since this script is made public, I made things a bit more convenient by storing literally everything in a variable. If you need to override any of the stock value, simply add the variable(s) that you want to override in battery.conf file so that you won't have to modify the script.

## HOW TO USE
1. Download the script: 
```bash
curl https://raw.githubusercontent.com/Hakimi0804/battery/master/battery.sh -so battery.sh
```
2. Execute it: 
```bash
bash battery.sh
```

## TROUBLESHOOTING

### design capacity is wrong
Use the script's config manager to change design capacity:
```bash
bash battery.sh -c set design_capacity your_device_design_capacity
```

### USB voltage is throwing error
Just like design capacity, you can override the path. Most of the time this line should fix it: 
```bash
bash battery.sh -c set path_voltage_usb "/sys/class/power_supply/usb/voltage_now"
```

### wrong voltage reading
- If the voltage is too small, you'll need to set the voltage unit to milivolt
- If the voltage is too large, you'll need to set the voltage unit to microvolt

Use one of the following lines depending on what voltage is broken (battery voltage/USB voltage)

```bash
bash battery.sh -c set config_voltage_unit "microvolt/milivolt"
bash battery.sh -c set config_voltage_unit_usb "microvolt/milivolt"
```

## EXTRAS
### updating the script
*Arguement to pass: `-u`, `--update`*

`bash battery.sh -u`
or
`bash battery.sh --update`

### overriding default values through the script itself
You can override default value by adding them to a file named battery.conf. In addition, you can use the provided tool to achieve that.

*Arguements to pass: `-c`, `--config` `<set/unset/get>` `[value]`*

*Available actions: set, unset, get*

**Examples:**

```bash
bash battery.sh -c set path_voltage_usb /sys/class/power_supply/usb/voltage_now
bash battery.sh -c unset path_voltage_usb
bash battery.sh -c get path_voltage_usb
```

### stock values list
```bash
nodepath="/sys/class/power_supply/battery"
default_nodepath="$nodepath"
design_capacity=4300
config_enable_vooc=1
config_voltage_unit="microvolt"
config_voltage_usb_unit="milivolt"
config_force_allow_for_non_termux=false
path_current="$nodepath/current_now"
path_voltage="$nodepath/voltage_now"
path_voltage_usb="$nodepath/../usb/device/ADC_Charger_Voltage"
path_capacity="$nodepath/capacity"
path_status="$nodepath/status"
path_temp="$nodepath/temp"
path_voocchg_ing="$nodepath/voocchg_ing"
path_fastcharger="$nodepath/fastcharger"
path_batt_fcc="$nodepath/batt_fcc"
```

## CREDITS
- myself
- 🤷‍♂️
- 🤷‍♂️
- 🤷‍♂️
