#!/system/bin/sh

# Greeting when flashing the module
ui_print "======================="
ui_print "     MSA-Disabler      "
ui_print "======================="
ui_print ""

# Get device information
BRAND=$(getprop ro.product.brand)
MANUFACTURER=$(getprop ro.product.manufacturer)

ui_print "- Checking device compatibility..."

# Safety check: Only Xiaomi, Redmi, or POCO
if [ "$BRAND" != "Xiaomi" ] && [ "$BRAND" != "Redmi" ] && [ "$BRAND" != "POCO" ] && \
   [ "$MANUFACTURER" != "Xiaomi" ]; then
  ui_print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  ui_print "! ERROR: Device not supported!       !"
  ui_print "! This module is for Xiaomi/Poco only!"
  ui_print "! Your device: $BRAND                !"
  ui_print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  abort "- Installation aborted."
fi

ui_print "- Compatible device detected: $BRAND"

# Conflict check
ui_print "- Scanning for conflicting adblock modules..."
CONFLICTS="adaway hosts-systemless energized_protection malware-blocks"
FOUND_CONFLICT=false

for MOD in $CONFLICTS; do
  if [ -d "/data/adb/modules/$MOD" ]; then
    ui_print "! Warning: Found potential conflict -> $MOD"
    FOUND_CONFLICT=true
  fi
done

if [ "$FOUND_CONFLICT" = true ]; then
  ui_print "--------------------------------------"
  ui_print "! PROCEED WITH CAUTION               !"
  ui_print "! Other adblockers detected.         !"
  ui_print "! Use this module at your own risk.  !"
  ui_print "--------------------------------------"
  sleep 3
fi

ui_print "- Setting permissions..."
set_perm_recursive $MODPATH 0 0 0755 0644
