#!/usr/bin/env Rscript

#---- format_featuretab2long.R ----
# 转换特征表为长表格，并添加样本对应项目ID

# 判断命令行解析是否安装，安装并加载
if (!suppressWarnings(suppressMessages(require("optparse", character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)))) {
  install.packages(p)
  require("optparse",character.only=T)
}
library("optparse")
option_list = list(make_option(c("-f", "--featuretab"), type="character", default="sum_g.txt", help="Taxonomy composition [default %default]"),
                   make_option(c("-m", "--metadata"), type="character", default="SraRunTable.txt", help="SampleID & ProjectID [default %default]"),
                   make_option(c("-o", "--output"), type="character", default="abundance.table.txt",help="Long feature table, include Project ID [default %default]"))         
opts <- parse_args(OptionParser(option_list=option_list))

#---- 读取文件 ----
featuretab <- read.table(opts$featuretab, header=T, na.strings=c ("NA"), sep="\t") # row.names = 1, 
SraRunTable <- read.table(opts$metadata, header=T, sep="\t")


#---- 数据转换 ----
c = featuretab
s = SraRunTable

# 删除All列
idx = colnames(c) %in% "All"
c = c[,!idx]

# 宽表格转换为长表格
library(reshape2)
c1 <- melt(c, id.vars = c(colnames(c)[1]))

# 过滤0值
c1 = c1 [c1$value > 0, ]

# 提取ID
s <- data.frame(y = s$Run, x = s$BioProject)

# 添加项目ID
finaltable <-merge(c1, s, by.x = 'variable', by.y = 'y', all.x = T)
 
# 调整列序列
finaltable <- finaltable[,c(2,1,3,4)]
# 命名表头
colnames(finaltable)<-c('Taxa', 'Sample',	'Abundance', 'Project_Accession')
finaltable$Abundance<-finaltable$Abundance/100

#---- 保存结果表 ----
write.table(finaltable, file = opts$output, row.names=F, quote=F, sep="\t")
