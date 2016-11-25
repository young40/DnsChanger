#!/bin/sh

#  install_helper.sh
#  DnsChanger
#
#  Created by Peter Young on 25/11/2016.
#  Copyright © 2016 Peter Young. All rights reserved.

cd `dirname "${BASH_SOURCE[0]}"`
sudo mkdir -p "/Library/Application Support/DnsChanger/"
sudo cp sysconf_helper "/Library/Application Support/DnsChanger/"
sudo chown root:admin "/Library/Application Support/DnsChanger/sysconf_helper"
sudo chmod +s "/Library/Application Support/DnsChanger/sysconf_helper"

echo done
