#!/bin/bash
#SBATCH -p grete:interactive            # this is a partition with slices of a GPU
#SBATCH -G 1g.20gb # 1g.20gb or 2g.10gb # Request 10gb or 20gb slices
#SBATCH -t 0-01:00:00                   # requested time

source /user/henrich1/u12041/.bashrc
export HTTPS_PROXY="http://www-cache.gwdg.de:3128"
export HTTP_PROXY="http://www-cache.gwdg.de:3128"
sleep infinity
