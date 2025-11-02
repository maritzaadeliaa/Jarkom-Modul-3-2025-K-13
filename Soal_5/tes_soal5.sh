#!/bin/bash
set -e

dig @10.70.3.20 www.K13.com +short

dig @10.70.3.20 CincinSauron.K13.com TXT +short
dig @10.70.3.20 AliansiTerakhir.K13.com TXT +short

dig @10.70.3.20 -x 10.70.3.20 +short
dig @10.70.3.20 -x 10.70.3.21 +short
