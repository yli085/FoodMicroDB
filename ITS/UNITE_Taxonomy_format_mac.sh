# 从UNITE数据中提取注释
cd UNITE_taxonomy

head unite_all_2021.5.10.fa
grep '>' unite_all_2021.5.10.fa | wc -l # 统计共有205,125行物种

# 筛选物种注释行，取物种注释列，排序，去冗余
grep '^>' unite_all_2021.5.10.fa | cut -f2 -d '='| sort | uniq  > unite_tax.txt

less unite_tax.txt | wc -l # 一共91,854
less unite_tax.txt | grep "d:Fungi" | wc -l # 其中真菌46,041
head -n3 unite_tax.txt

# 筛选物种注释，制作成Phylum对应的各级名称
sed 's/,c:/\t/' unite_tax.txt | cut -f1 | grep ',p:' \
|sed 's/,g:/\t/' | cut -f1| sed 's/,f:/\t/' | cut -f1| sed 's/,o:/\t/' |cut -f1| sed 's/,s:/\t/' | cut -f1 \
|sort | uniq |sed 's/,p:/\t/;s/;$//' \
|awk '{print $2"\t"$1";"$2}' | sed 's/[a-z]://g;s/,/;/g' > unite_Phylum.txt
      
head unite_Phylum.txt
wc -l unite_Phylum.txt # 130

# 筛选物种注释，制作成Class对应的各级名称
sed 's/,o:/\t/' unite_tax.txt | cut -f1 | grep ',c:' \
|sed 's/,g:/\t/' | cut -f1| sed 's/,f:/\t/' | cut -f1| sed 's/,s:/\t/' | cut -f1 \
|sort | uniq |sed 's/,c:/\t/;s/;$//' \
|awk '{print $2"\t"$1";"$2}' | sed 's/[a-z]://g;s/,/;/g' > unite_Class.txt
      
head unite_Class.txt
wc -l unite_Class.txt # 306

# 筛选物种注释，制作成Order对应的各级名称
sed 's/,f:/\t/' unite_tax.txt | cut -f1 | grep ',o:' \
|sed 's/,g:/\t/' | cut -f1| sed 's/,s:/\t/' | cut -f1 \
|sort | uniq |sed 's/,o:/\t/;s/;$//' \
|awk '{print $2"\t"$1";"$2}' | sed 's/[a-z]://g;s/,/;/g' > unite_Order.txt

head unite_Order.txt
wc -l unite_Order.txt # 1010

# 筛选物种注释，制作成Family对应的各级名称
sed 's/,g:/\t/' unite_tax.txt | cut -f1 | grep ',f:' \
|sed 's/,s:/\t/' | cut -f1\
|sort |uniq |sed 's/,f:/\t/;s/;$//' \
| awk '{print $2"\t"$1";"$2}' | sed 's/[a-z]://g;s/,/;/g' > unite_Family.txt

head unite_Family.txt
wc -l unite_Family.txt # 3065

# 筛选物种注释，制作成Genus对应的各级名称
sed 's/,s:/\t/' unite_tax.txt | cut -f1 | grep ',g:' \
|sort | uniq |sed 's/,g:/\t/;s/;$//' \
|awk '{print $2"\t"$1";"$2}' | sed 's/[a-z]://g;s/,/;/g' > unite_Genus.txt

head unite_Genus.txt
wc -l unite_Genus.txt # 20211

# 筛选物种注释，制作成Species对应的各级名称, 不用cut -f1了
sed 's/,s:/\t/;s/;$//' unite_tax.txt | awk '{print $2"\t"$1";"$2}' | sed 's/[a-z]://g;s/,/;/g' > unite_Species.txt

head unite_Species.txt
wc -l unite_Species.txt # 91854
