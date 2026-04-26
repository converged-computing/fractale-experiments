#!/usr/bin/sh
# Copyright (C) 2018 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

#FLUX: --nodes=8
#FLUX: --ntasks=8
#FLUX: --cores-per-task=2
#FLUX: --time-limit=1h

# The PBS '-j oe' directive is handled by directing both output streams to the same file.
#FLUX: --output=flux_job_%J.out
#FLUX: --error=flux_job_%J.out

# The pbsdsh command is replaced by the standard flux launcher `flux mini run`
# The number of tasks (-n 8) is derived from `select=8` and `mpiprocs=1`.
flux mini run -n 8 ~/dai/AMG 1
