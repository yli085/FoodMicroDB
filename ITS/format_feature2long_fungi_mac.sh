# NOTES: 
# mac版 use ggrep instead of grep
# Usage:转换特征表为长表格，并添加样本对应项目ID

# 工作路径
pwd
cd ..

# # 显示帮助
# Rscript script/format_feature2long.R -h
# # # 测试输入和输出文件
# Rscript script/format_feature2long.R --featuretab sum_g.txt --metadata SraRunTable.txt --output abundance.table.txt
# # 循环处理 - 门-种水平

# 每一个分类(p c o f g)，建立一个folder
mkdir temp
for j in p c o f g; do
  mkdir -p temp/${j}
  # 当前目录里每一个project，做一次转换特征表为长表格
  for i in `ls | ggrep -P ^PRJ | sed 's/\///'`; do
    Rscript script/format_feature2long.R --featuretab $i/result/tax/sum_${j}.txt --metadata $i/result/SraRunTable.txt --output temp/${j}/${i}.txt
  done  
done

# 合并所有样品
# 获得表头
head -n1 temp/p/`ls temp/p/ | head -n1` > temp/Fungi.Composition.Phylum.abundance.table.txt
head -n1 temp/c/`ls temp/c/ | head -n1` > temp/Fungi.Composition.Class.abundance.table.txt
head -n1 temp/o/`ls temp/o/ | head -n1` > temp/Fungi.Composition.Order.abundance.table.txt
head -n1 temp/f/`ls temp/f/ | head -n1` > temp/Fungi.Composition.Family.abundance.table.txt
head -n1 temp/g/`ls temp/g/ | head -n1` > temp/Fungi.Composition.Genus.abundance.table.txt

# 添加信息, grep -v 'Project_Accession' 去除首行，再合并加到之前的表头里
cat temp/p/* | grep -v 'Project_Accession' >> temp/Fungi.Composition.Phylum.abundance.table.txt
cat temp/c/* | grep -v 'Project_Accession' >> temp/Fungi.Composition.Class.abundance.table.txt
cat temp/o/* | grep -v 'Project_Accession' >> temp/Fungi.Composition.Order.abundance.table.txt
cat temp/f/* | grep -v 'Project_Accession' >> temp/Fungi.Composition.Family.abundance.table.txt
cat temp/g/* | grep -v 'Project_Accession' >> temp/Fungi.Composition.Genus.abundance.table.txt

# cleanup
mkdir -p local/Abundance
mv temp/Fungi.Composition.* local/Abundance

# 分析单个实例数据
# cd $wd/16s
# mkdir -p temp/genus
# Rscript $wd/script/format_feature2long.R --featuretab 221213Africa/temp/tax/sum_g.txt --metadata 221213Africa/SraRunTable.txt --output temp/genus/221213Africa.txt

# # # 批处理实例数据- 属水平
# for i in `ls | grep -P ^2 | sed 's/\///'`; do
#   Rscript $wd/script/format_feature2long.R --featuretab $i/temp/tax/sum_g.txt --metadata $i/SraRunTable.txt --output temp/genus/${i}.txt
# done  
# # 批处理实例数据- 门水平
# mkdir -p temp/p
# for i in `ls | grep -P ^2 | sed 's/\///'`; do
#   Rscript $wd/script/format_feature2long.R --featuretab $i/temp/tax/sum_p.txt --metadata $i/SraRunTable.txt --output temp/p/${i}.txt
# done  