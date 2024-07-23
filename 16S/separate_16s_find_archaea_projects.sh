## find 16S projects that do not have archaea data.

# pwd
cd local/Abundance

# 从 Bac abundance 提取 all projects. 验证是否涵盖所有项目。
less Bacteria.Composition.Phylum.abundance.table.txt | cut -f4 | tail -n+2 | sort | uniq > bac.project.txt 

# 从archaea abundance中提取archaea projects，这些Kingdom要改成both
less Archaea.Composition.Phylum.abundance.table.txt | cut -f4 | tail -n+2 | sort | uniq > arc.project.txt 
