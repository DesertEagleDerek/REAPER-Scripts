# API Script

Full scripts that serve a purpose while mixing. These are either personal scripts or were created to satisfy a users request.

&nbsp;
## reasonus_api_control_mapped_plugin_on_track.lua

This script was created after a user request for gain control after all other plugins in the FX list. Instead of modifying ReaSonus Native to support this, I used the plugin mapping feature to serve as a workaround.

After selecting a single track and running the script, it will scan the FX list of that track for a preconfigured plugin name and if that name is found then it will open a floating window and switch the FP8/16 to plugin mode to control that plugin. Running the script again while the floating window is open will close the floating window and switch back to track mode to resume mixing.

The script can target a specific ordered instance of the plugin within the FX list or only select the last instance (which is what's assumed to satisfy the original request). The found instance can also be moved to a target index within the FX list, making it possible to reorder the plugin (moving it to the end to satisfy the original request). If the plugin is not found then there is an option to add the plugin so that running the script will always show a floating window, even if you've not yet prepared the track with your plugin (important for the original request because all tracks are always supposed to have gain available as the last plugin). There's also an option to close all floating windows before opening the plugin floating window, to help de-clutter the workspace before controlling the target plugin.

### How to prepare

1. Add your plugin to ReaSonus using the plugin mapping page in the control panel

2. Add the parameter you want to control to a fader in your plugin mapping

3. Add your plugin to a track and copy the name **exactly as shown** in the FX window using rename option

4. Paste the name you just copied from the FX window into the `targetName` variable of the script

5. Select a track and run the script (map the script to a function key or button to make this easier)

Here's an example video showing steps 1 to 4 with the kilohearts gain plugin:

https://github.com/user-attachments/assets/81eae418-7ac5-459f-97a7-a26768b42d7b

### Thoughts

It's possible to accidentally reorder the wrong plugin instance if you have multiple instances and are not careful. In the case of the example above where the user expects gain to be the last plugin, they should be only using a single instance or if multiple gain stages are needed then perhaps use a different gain plugin for the final gain plugin to completely avoid this kind of issue.

After creating this script, I made several copies of it and changed the `targetName` to my most used plugins. When I want to add those plugins, I use the script instead of adding them through the FX browser. This makes the plugin accessible immediately from a single press on either a FP16 function key or button on another control surface. Since the script can open and close the plugin control, I can make initial changes and easily go back later to make adjustments, all with the same function key or button!
