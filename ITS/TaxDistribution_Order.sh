# Usage: 将微生物的存在的宿主，项目，样本数进行统计

# NOTES
# compared to linux, "sed 1i" not working on mac, so using "echo -e" and append instead.

# 工作目录


**分析过程**:


# 1. 预处理：筛选丰度大于0的值
    t=Fungi.Composition.Order.abundance.table.txt
    head $t
    wc -l $t # 统计共有多少行

    # 删除第三列为0的行，删除第一列是Unassigned的行
    awk '$3>0 && $1!="Unassigned"&& $1!="(Unassigned)"' $t > ${t}_0.txt
    head ${t}_0.txt 
    wc -l ${t}_0.txt # xx行在表内第三列为非0，去除Unassigned后剩下xx列

    #提取项目所有tax名称
    tail -n+2 ${t}_0.txt|cut -f1 |sort|uniq > ${t}_1.txt
    head ${t}_1.txt
    wc -l ${t}_1.txt

# 2.**物种注释**

    # 提取本次所需
    awk 'BEGIN{FS=OFS="\t"} NR==FNR{a[$1]=$2} NR>FNR{print $1,a[$1]}' ../UNITE_taxonomy/unite_Order.txt ${t}_1.txt > ${t}_2.txt
    head ${t}_2.txt
    # wc -l ${t}_2.txt
    

# 3.**Host统计**
# 需要样本对应Host表：../ITS_sample_metadata.txt

    # 添加name，制作sampleID与食物name对应表：多列时会出现格式异常,此处手动从制作的16s_sample_metadata.xlsx中提出SampleID和Name这两列，制成txt文件
    # cat ../ITS_sample_metadata.txt |head -n3

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

    # mkdir -p TaxaDistribution
    # 统计所有文件行数
    wc -l ${t}_*
    # 制作表头，添加内容
    echo -e "Order\tTaxonomy\tHosts\tBioprojects\tSamples" > TaxaDistribution/Fungi_TaxDistribution_Order.txt
    paste ${t}_2.txt ${t}_3.txt ${t}_4.txt ${t}_5.txt | cut -f1,2,4,6,8 >> TaxaDistribution/Fungi_TaxDistribution_Order.txt

# 其中Order.Fun.tax.list.txt 放在Tax_list文件夹
#把${t}_host.txt文件去掉name列没有的行，并重命名表头, 并重命名成Order.Fun.tax.Host.txt
   echo -e "Order\tSample\tAbundance\tProject_Accession\tName" > Order.Fun.tax.Host.txt
   ggrep -v -P '\t$' ${t}_host.txt | sort -k5,5 >> Order.Fun.tax.Host.txt
   head Order.Fun.tax.Host.txt
   
#对${t}_2.txt文件加上表头，并重命名成Order.Fun.tax.txt
   echo -e "Order\tTaxonomy" > Order.Fun.tax.txt
   cat ${t}_2.txt >> Order.Fun.tax.txt
#把Order.Fun.tax.txt文件第二列拆分，并重命名
    # mkdir -p Tax_list
    echo -e "Taxonomy\tKingdom\tPhylum\tClass\tOrder" > Tax_list/Order.Fun.tax.list.txt
    sed 's/;/\t/g' Order.Fun.tax.txt | tail -n+2 >> Tax_list/Order.Fun.tax.list.txt
    head Tax_list/Order.Fun.tax.list.txt
    
    