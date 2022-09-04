#!/usr/bin/env bash

# Policy for not receiving rfkill message after boot when bluetooth is enable by default
sudo echo '
polkit.addRule(function(action, subject) {
    if ((action.id == "org.blueman.rfkill.setstate" ||
         action.id == "org.blueman.network.setup") &&
         subject.local && subject.active && subject.isInGroup("wheel")) {

        return polkit.Result.YES;
    }
});
' > /etc/polkit-1/rules.d/81-blueman.rules
