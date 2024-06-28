#!/bin/bash

ARCH=$(uname -m)

/usr/bin/soffice --headless || [ $? -eq 81 ] || exit 1
