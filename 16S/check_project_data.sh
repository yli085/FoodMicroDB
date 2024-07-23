
# 1. 将目标项目名列表放在一个文件中
vi project_16S_list.txt

# 2. 查找现在已有文件夹，并项目列表放在另外一个文件中
# separate the names by "P" and then add it back
ll .. | grep PRJ | cut -d"P" -f2 | cut -d"_" -f1 > current_projects.txt
mv current_projects.txt names.txt # temp file

# add P to the front and output to the original name of file
output_file="current_projects.txt"  # Name of the output file
# Read each line (name) from names.txt
while IFS= read -r name; do
    # Add "P" to the beginning of each name and append to output file
    echo "P${name}" >> "$output_file"
done < names.txt

# 3. 对比两个文件，找出差异
sort -u current_projects.txt > current_projects_s.txt
sort -u project_16s_list.txt > project_16s_list_s.txt
diff project_16s_list_s.txt current_projects_s.txt

################简化版###################
ll temp/g | grep PRJ | cut -d":" -f2 | cut -d" " -f2 | cut -d"." -f1 | cut -d"_" -f1 | sort > current_projects.txt
diff project_16s_list.txt current_projects.txt

