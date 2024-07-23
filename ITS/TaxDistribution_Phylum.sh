# Usage: 将微生物的存在的宿主，项目，样本数进行统计

# NOTES
# compared to linux, "sed 1i" not working on mac, so using "echo -e" and append instead.

# 工作目录
pwd
cd local/Abundance
# wd="/Users/yahui/Desktop/Liu_lab/FoodMicroDB/add_data/newdata1122/Projects/local/Abundance"


# **输入文件**:
# 
# 丰度表：分类、样本名、丰度、项目名class.Fun.Composition.abundance.table.txt
# 
#     Taxa	Sample	Abundance	Project_Accession
#     Planctomycetacia	ERR3347686	0.05	PRJEB32455
#     Blastocatellia	ERR3347686	0.51	PRJEB32455
#     Clostridia	ERR3347686	0.002	PRJEB32455
#
# **输出文件**：
# 
# Fungi_composition_Class.txt，添加宿主、项目、样本统计数
# 
#     Name	Taxonomy	Hosts	Bioprojects	Samples
#     Chlorobia	Fungi;Chlorobi;Chlorobia	23	21	173
#     Acidobacteria Gp3	Bacteria;Acidobacteria;Acidobacteria Gp3	141	116	1637
#     Acidobacteria Gp14	Bacteria;Acidobacteria;Acidobacteria Gp14	3	3	27


# 1. 预处理：筛选丰度大于0的值
    t=Fungi.Composition.Phylum.abundance.table.txt
    head $t
    wc -l $t # 统计共有多少行

    # 删除第三列为0的行，删除第一列是Unassigned的行
    awk '$3>0 && $1!="Unassigned" && $1!="(Unassigned)"' $t > ${t}_0.txt
    head ${t}_0.txt 
    wc -l ${t}_0.txt # xx行在表内第三列为非0，去除Unassigned后剩下xx列

    #提取项目所有tax名称
    tail -n+2 ${t}_0.txt|cut -f1 |sort|uniq > ${t}_1.txt
    head ${t}_1.txt
    wc -l ${t}_1.txt

# 2.**物种注释**

# **输入文件**：
# Fungi.Composition.phylum.abundance.table.txt_1.txt, or ${t}_1.txt
# ../UNITE_taxonomy/unite_Phylum.txt

# **输出文件**: ${t}_2.txt


    # 提取本次所需
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print $1,a[$1]}' ../UNITE_taxonomy/unite_Phylum.txt ${t}_1.txt > ${t}_2.txt
    head ${t}_2.txt
    # wc -l ${t}_2.txt
    

# 3.**Host统计**
# 需要样本对应Host表：ITS_sample_metadata.txt

    # 添加Host name，制作sampleID与食物name对应表：多列时会出现格式异常,此处手动从制作的16s_sample_metadata.xlsx中提出SampleID和Name这两列，分别作为第一和第二列，做为txt格式
    cat ../ITS_sample_metadata.txt|head -n3
    # first file: c1: key; c2: value
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print $0,a[$2]}' ../ITS_sample_metadata.txt ${t}_0.txt > ${t}_host.txt
    head -n3 ${t}_host.txt
    
    # 统计host数量
    tail -n+2 ${t}_host.txt|cut -f1,5 | sort | uniq | cut -f1 | uniq -c | awk '{print $2"\t"$1}' > ${t}_3.txt
    head ${t}_3.txt
    # wc -l ${t}_3.txt

# 4. 统计Bioproject项目数量

    tail -n+2 ${t}_host.txt|cut -f1,4 | sort | uniq | cut -f1 | uniq -c | awk '{print $2"\t"$1}' > ${t}_4.txt
    head -15 ${t}_4.txt

# 5. 统计Samples数量

    tail -n+2 ${t}_host.txt|cut -f1 | sort | uniq -c | awk '{print $2"\t"$1}' > ${t}_5.txt
    head ${t}_5.txt

# 6. 合并5列数据
    mkdir -p TaxaDistribution
    #统计所有文件行数
    wc -l ${t}_*
    # 制作表头
    echo -e "Phylum\tTaxonomy\tHosts\tBioprojects\tSamples" > TaxaDistribution/Fungi_TaxDistribution_Phylum.txt
    # 添加内容
    paste ${t}_2.txt ${t}_3.txt ${t}_4.txt ${t}_5.txt | cut -f1,2,4,6,8 >> TaxaDistribution/Fungi_TaxDistribution_Phylum.txt

    head -n3 TaxaDistribution/Fungi_TaxDistribution_Phylum.txt
  
## 保存其他过程文件
# 其中Phylum.Fun.tax.list.txt 放在Tax_list文件夹
#把${t}_host.txt文件去掉name列没有的行，并重命名表头, 并重命名成Phylum.Fun.tax.Host.txt
   echo -e "Phylum\tSample\tAbundance\tProject_Accession\tName" > Phylum.Fun.tax.Host.txt
   ggrep -v -P '\t$' ${t}_host.txt | sort -k5,5 >> Phylum.Fun.tax.Host.txt
   head Phylum.Fun.tax.Host.txt
   
#对${t}_2.txt文件加上表头，并重命名成Phylum.Fun.tax.txt
   echo -e "Phylum\tTaxonomy" > Phylum.Fun.tax.txt
   cat ${t}_2.txt >> Phylum.Fun.tax.txt
#把Phylum.Fun.tax.txt文件第二列拆分，并重命名
    mkdir -p Tax_list
    echo -e "Taxonomy\tKingdom\tPhylum" > Tax_list/Phylum.Fun.tax.list.txt
    sed 's/;/\t/g' Phylum.Fun.tax.txt | tail -n+2 >> Tax_list/Phylum.Fun.tax.list.txt
    head Tax_list/Phylum.Fun.tax.list.txt
   
