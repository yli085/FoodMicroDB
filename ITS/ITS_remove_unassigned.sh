
# for ITS Abundance data, 剔除Unassigned


# input: Abundance文件夹
# output: 剔除了丰度里Unassigned的行

# work directory
cd local/Abundance

# the file name, loop step
# Change from p to g: Phylum, Class, Order, Family, Genus
for i in Phylum Class Order Family Genus; do
  t=Fungi.Composition.${i}.abundance.table.txt
  # make bak
  mv $t ${t}_bak.txt
  grep -v 'Unassigned' ${t}_bak.txt > $t
done 

  # save all bak file
  mkdir original/
  mv *bak* original