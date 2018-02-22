# NAME
piranha.sh
# VERSION
0.9
# DEPENDENCIES
- `Piranha`
- `sort`
# DESCRIPTION
Uses the aligned CLIP-reads to identifiy signal regions of AGO-binding. The resulting `.bed` file is then sorted.
# PARAMETERS
`Piranha`:

- `-o` := output
- `-s` := sort

`sort`:
- `-k1,1 -k2,2n` := sorting the bed file
# INPUT
- `SRR_trim_gsnap.bed`
# OUTPUT
- `SRR_trim_gsnap_piranha_sort.bed`
# CHANGELOG
- 2018-02-12 Release version 0.9
# KNOWN BUGS
no known bugs
# LICENSE
This program is released under GPLv2. For further license information, see LICENSE.md shipped with this program.
Copyright(c)2018 Daniel Amsel and Frank Förster (employees of Fraunhofer Institute for Molecular Biology and Applied Ecology IME).
All rights reserved.
# CONTACT
daniel.amsel@ime.fraunhofer.de
frank.foerster@ime.fraunhofer.de