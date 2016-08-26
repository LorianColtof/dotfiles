from i3pystatus import Status
import os

status = Status(standalone=True)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM Week 31
#                          ^-- calendar week
status.register("clock",
    format="%a %-d %b %Y %T Week %V",
)

# Show CPU usage bar
status.register("cpu_usage_bar",
	format="CPU:{usage_bar}",)

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
    format="{temp:.0f}°C",)

if os.path.isdir("/sys/class/backlight/intel_backlight"):
	status.register("backlight",
		format="Backlight: {percentage}%",
		backlight="intel_backlight"
		)


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
		format="{status} |{bar_design}| {percentage_design:.0f}% {remaining:%E%hh:%Mm} {consumption:.2f}W",
		not_present_text="(no battery)",
		alert=False,
		alert_percentage=4,
		color='#4b6dff',
		status={
			"DIS": "↓",
			"CHR": "↑",
			"FULL": "=",
		},)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
    interface="enp3s0",
	format_down="{interface}",
    format_up="{interface}: {v4cidr}",)

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlp5s0",
	format_down="{interface}",
    format_up="{interface}: {essid} {quality:03.0f}% ({v4cidr})",)

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
    path="/",
    format="{used}/{total}GB [{avail}GB]",)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
    format="{muted} ♪ {volume}%",
    muted=" (muted)"
)


status.run()
