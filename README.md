# battery
Was gonna keep this private but someone requested it 🤷‍♂️ sooo
don't complain about it being stupid or anything.
However issues are welcome.

## convenience
Since this script is made public, I made things a bit more convenient by storing literally everything in a variable. If you need to override any of the stock value, simply add the variable(s) that you want to override in battery.conf file so that you won't have to modify the script.

## how to use
1. Download the script: `curl https://raw.githubusercontent.com/Hakimi0804/battery/master/battery.sh -so battery.sh`
2. Execute it: `bash battery.sh`

## troubleshooting & extras
### design capacity is wrong!
Well, that's where the battery.conf comes in handy. Use it to overwrite the default design capacity variable. Add this line to do so: `design_capacity=your_device_design_capacity`

### USB voltage is throwing error
Just like design capacity, you can override the path. Most of the time this line should fix it: `path_voltage_usb="/sys/class/power_supply/usb/voltage_now"`

### wrong voltage reading
- If the voltage is too small, you'll need to set the voltage unit to milivolt
- If the voltage is too large, you'll need to set the voltage unit to microvolt

Use one of the following lines depending on what voltage is broken (battery voltage/USB voltage)

`config_voltage_unit="microvolt/milivolt"`

`config_voltage_unit_usb="microvolt/milivolt"`

## credits
- myself
- 🤷‍♂️
- 🤷‍♂️
- 🤷‍♂️
- 🤷‍♂️
