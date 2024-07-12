## for 16S data, we separate all files into Bacteria category and Archaea, mainly by the 'grep' command.
# 同时Unassigned被自动剔除，只剩Bacteria和Archaea物种
# input: 不同项目合并之后的5个文件夹
# output: 16S分开后的5个文件夹

# work directory, containing 5 folders
cd local/Abundance

################### Tax_list ####################
cd ../Tax_list

# the file name 
# Change from p to g: Phylum, Class, Order, Family, Genus
# loop for each level
for i in Phylum Class Order Family Genus; do
    t=${i}.Bac.tax.list.txt
    t2=${i}.Arc.tax.list.txt
    # make bak
    mv $t ${t}_bak.txt
    # extract Bac
    grep 'Bacteria' ${t}_bak.txt > temp
    head -n1 ${t}_bak.txt > $t
    cat temp >> $t
    # extract Archaea
    grep 'Archaea' ${t}_bak.txt > temp
    head -n1 ${t}_bak.txt > $t2
    cat temp >> $t2
    # lastly remove files
    rm temp
done
    # clean-up
    mkdir original
    mv *bak* original/

################### Tax_list_combined ####################
cd ../Taxa_list_combined

# the file name 
# Change from p to g: Phylum, Class, Order, Family, Genus
# loop for each level
for i in Phylum Class Order Family Genus; do
    t=${i}.Bac.tax.txt
    t2=${i}.Arc.tax.txt
    # make bak
    mv $t ${t}_bak.txt
    # extract Bac
    grep 'Bacteria' ${t}_bak.txt > temp
    head -n1 ${t}_bak.txt > $t
    cat temp >> $t
    # extract Archaea
    grep 'Archaea' ${t}_bak.txt > temp
    head -n1 ${t}_bak.txt > $t2
    cat temp >> $t2
    # lastly remove files
    rm temp
done
    # clean-up
    mkdir original
    mv *bak* original/

################### TaxaDistribution ####################
cd ../TaxaDistribution

# the file name 
# Change from p to g: Phylum, Class, Order, Family, Genus
# loop for each level
for i in Phylum Class Order Family Genus; do
    t=Bacteria_TaxDistribution_${i}.txt
    t2=Archaea_TaxDistribution_${i}.txt
    # make bak
    mv $t ${t}_bak.txt
    # extract Bac
    grep 'Bacteria' ${t}_bak.txt > temp
    head -n1 ${t}_bak.txt > $t
    cat temp >> $t
    # extract Archaea
    grep 'Archaea' ${t}_bak.txt > temp
    head -n1 ${t}_bak.txt > $t2
    cat temp >> $t2
    # lastly remove files
    rm temp
done
    # clean-up
    mkdir original
    mv *bak* original/


###################### Abundance #####################
cd ../Abundance

# manually replace those words in the file name: Phylum, Class, Order, Family, Genus;
# also change the RDP mapping table: Phylum, Class, Order, Family, Genus
# loop for each level
for i in Phylum Class Order Family Genus; do
    t=Bacteria.Composition.${i}.abundance.table.txt
    tarc=Archaea.Composition.${i}.abundance.table.txt
    # make bak
    mv $t ${t}_bak.txt

    # 去除header
    tail -n+2 ${t}_bak.txt > ${t}_1.txt
    # 利用匹配添加RDP物种注释到最后一列
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print $0,a[$1]}' ../RDP_taxonomy/rdp_16s_v18_${i}.txt ${t}_1.txt > ${t}_2.txt

    # 分开Archaea和Bacteria
    # extract Bac
    grep 'Bacteria' ${t}_2.txt |cut -f1-4 > ${t}_3.txt 
    # add the header to the file
    head -n1 ${t}_bak.txt > $t
    paste ${t}_3.txt >> $t
    # extract Arc
    grep 'Archaea' ${t}_2.txt |cut -f1-4 > ${t}_4.txt 
    # add the header to the file
    head -n1 ${t}_bak.txt > ${tarc}
    paste ${t}_4.txt >> ${tarc}

    # last step, clean-up: remove temp files
    rm *_1.txt *_2.txt *_3.txt *_4.txt 
done
# save the bak files
mkdir original
mv *_bak.txt original/

###################### Taxa_host #####################
cd ../Taxa_host

# The file name
# manually replace those words in the file name, one by one: Phylum, Class, Order, Family, Genus; 
# also change the RDP mapping table: Phylum, Class, Order, Family, Genus
for i in Phylum Class Order Family Genus; do
    t=${i}.Bac.tax.Host.txt
    tarc=${i}.Arc.tax.Host.txt
    # make bak
    mv $t ${t}_bak.txt

    # 去除header
    tail -n+2 ${t}_bak.txt > ${t}_1.txt
    # 利用匹配添加RDP物种注释到最后一列
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print $0,a[$1]}' ../RDP_taxonomy/rdp_16s_v18_${i}.txt ${t}_1.txt > ${t}_2.txt

    # 分开Archaea和Bacteria
    # extract Bac
    grep 'Bacteria' ${t}_2.txt |cut -f1-5 > ${t}_3.txt 
    # add the header to the file
    head -n1 ${t}_bak.txt > $t
    paste ${t}_3.txt >> $t
    # extract Arc
    grep 'Archaea' ${t}_2.txt |cut -f1-5 > ${t}_4.txt 
    # add the header to the file
    head -n1 ${t}_bak.txt > ${tarc}
    paste ${t}_4.txt >> ${tarc}

    # last step, clean-up: remove temp files
    rm *_1.txt *_2.txt *_3.txt *_4.txt 
done

# save original files
mkdir original 
mv *_bak.txt original/
