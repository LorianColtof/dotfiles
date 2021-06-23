from i3pystatus import Status
import os
import netifaces
from enum import Enum


status = Status(standalone=True)

homedir = os.getenv('HOME')

if os.path.isfile(os.path.join(homedir, '.colors_light')):
    class Color(Enum):
        RED = '#9d0006'
        GREEN = '#379c09'
        BLUE = '#076678'
else:
    class Color(Enum):
        RED = '#ff0000'
        GREEN = '#00ff00'
        BLUE = '#4b6dff'


# Displays clock like this:
# Tue 30 Jul 11:59:46 PM Week 31
#                          ^-- calendar week
status.register("clock", format="%a %-d %b %Y %T Week %V")

# Show CPU usage bar
status.register("cpu_usage_bar", format="CPU:{usage_bar}",
                start_color=Color.GREEN.value, end_color=Color.RED.value)

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp", format=" {temp:.0f}°C")

if os.path.isdir("/sys/class/backlight/intel_backlight"):
    status.register("backlight", format=" {percentage}%",
                    backlight="intel_backlight")


# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
if os.path.isdir("/sys/class/power_supply/BAT0"):
    status.register("battery",
                    format="{status} |{bar}| {percentage:.2f}% {remaining:%E%hh:%Mm} {consumption:.2f}W",  # noqa
                    not_present_text="(no battery)",
                    interval=5,
                    alert=True,
                    alert_percentage=15,
                    color=Color.BLUE.value,
                    full_color=Color.GREEN.value,
                    charging_color=Color.GREEN.value,
                    critical_color=Color.RED.value,
                    status={
                        "DLP": "",
                        "DIS": "",
                        "CHR": "",
                        "FULL": " ",
                    })


eth = None
wlan = None

for interface in netifaces.interfaces():
    if interface.startswith('w'):
        wlan = interface
    elif interface.startswith('e'):
        eth = interface

# Shows the address and up/down state of eth0. If it is up the address is shown
# in green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
if eth:
    status.register("network",
                    interface=eth,
                    color_up=Color.GREEN.value, color_down=Color.RED.value,
                    format_down=" {interface}",
                    format_up=" {interface}: {v4cidr}",
                    on_upscroll=None, on_downscroll=None)

# Note: requires both netifaces and basiciw (for essid and quality)
if wlan:
    status.register(
        "network", interface=wlan,
        color_up=Color.GREEN.value, color_down=Color.RED.value,
        format_down=" {interface}",
        format_up=" {interface}: {essid} {quality:03.0f}% ({v4cidr})",
        on_upscroll=None, on_downscroll=None)

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
                path="/",
                format=" {used}/{total}GB [{avail}GB]")

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
                format="♪ {muted}{volume}%",
                color_muted=Color.RED.value,
                muted="(muted) ")


if os.path.isfile("/proc/acpi/bbswitch"):
    status.register(
        "shell", format="GPU: {output: >3s}",
        interval=1, color=Color.GREEN.value,
        error_color=Color.RED.value,
        on_doubleleftclick=os.path.join(homedir,
                                        "dotfiles/scripts/gpu/gpu-switch toggle"),
        command=os.path.join(homedir, "dotfiles/scripts/gpu/i3pystatus_gpu.sh"))

status.run()
