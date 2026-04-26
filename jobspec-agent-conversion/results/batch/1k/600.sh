#!/bin/bash
#FLUX: --job-name=rsync2dogwood
#FLUX: --output=/u/shelley.melchior/rsync_dogwood.out
#FLUX: --error=/u/shelley.melchior/rsync_dogwood.out
#FLUX: --nodes=1
#FLUX: --cores=1
#FLUX: --time-limit=2h

# The PBS memory request (-l mem=1000MB) has no direct analog in the provided flux submit options.
# The -A (account) and -q (queue) directives were ignored as per instructions.

module load rsync/3.2.2

#dtgarr="20240313"
dtgarr="20240320 20240321 20240322 20240323"
for dtg in ${dtgarr[@]}
do
  echo $dtg
  echo "rsync -ahr -P /lfs/h2/emc/vpppg/noscrub/shannon.shields/EVS_Data/evs/v1.0/prep/subseasonal/atmos.$dtg ddxfer.wcoss2.ncep.noaa.gov:/lfs/h2/emc/vpppg/noscrub/shelley.melchior/forSS/."
  rsync -ahr -P /lfs/h2/emc/vpppg/noscrub/shannon.shields/EVS_Data/evs/v1.0/prep/subseasonal/atmos.$dtg ddxfer.wcoss2.ncep.noaa.gov:/lfs/h2/emc/vpppg/noscrub/shelley.melchior/forSS/.
done

#rsync -ahr -P /lfs/h2/emc/vpppg/noscrub/shannon.shields/EVS_Data/evs/v1.0/prep/subseasonal/atmos.20240312 ddxfer.wcoss2.ncep.noaa.gov:/lfs/h2/emc/vpppg/noscrub/shelley.melchior/forSS/.
