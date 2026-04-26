#!/bin/bash


#FLUX: --job-name=mussic
#FLUX: --nodes=1
#FLUX: --cores=2
#FLUX: --time-limit=4h

# NOTE: Complex output/error naming from PBS is not supported.
# Default output/error files will be used.


cd /home/yss265/MusicClassification/data
wget http://opihi.cs.uvic.ca/sound/genres.tar.gz
tar -zxvf genres.tar.gz

cd /home/yss265/MusicClassification/data/genres
module load sox/intel/14.4.1
cp ../process.sh .
sh process.sh

cd /home/yss265/MusicClassification/data
module load scipy/intel/0.13.3
python pythonrize.py

cd /home/yss265/MusicClassification/data
rm -rf genres genres_processed genres.tar.gz

exit 0;
