#!/bin/bash -e

systemctl disable snapd.service
# systemctl disable snapd.socket
systemctl disable snapd.seeded.service
systemctl disable snapd-recovery-chooser-trigger.service
