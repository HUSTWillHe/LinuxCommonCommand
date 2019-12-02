[TOC]
*约定:*  
*命令行语法中:“[]”中的内容表示可选参数;“<>”中的内容表示必选参数;“{}”中用“｜”分隔开的内容表示选择范围；“...”表示多项相同参数。*  
*命令的测试环境为Ubuntu 16.04.6 LTS*  
# 一、基础命令 
## 1. 文件及目录操作
### cd
**作用:**  
切换目录  
**语法:**  
```bash
cd <dirName>
```
**常见用法：**  
```bash
cd .. #切换到上一级目录
cd ../.. #切换到上上级目录
cd ... #oh-my-zsh中的用法，切换到上上级目录
cd ~ #切换到用户主目录
cd / #切换到系统根目录
cd - #相当于cd $OLDPWD,返回跳转至当前目录的目录
cd #与"cd ~"作用相同，切换到用户主目录
```
由于分隔上下级目录的斜杠'/'有多个不会对结果有影响，所以写脚本是涉及路径名文件名倾向于向路径名后面和文件名前面加'/'。  
### pushd/popd/dirs
**作用:**  
pushd和popd是对一个目录栈进行操作，dirs是显示目录栈的内容。目录栈是一个保存目录的栈结构，栈的顶端永远存放着当前目录(后续会不断体现)。  
**语法:**  
```bash
pushd [dirName]
popd
dirs [options]
```
**常见用法：**  
```bash
dirs -v #将目录栈中的目录分行显示，并显示序号
dirs -c #清除目录栈中目录
pushd ~/Workspace #切换到~/Workspace目录，并将该目录放到栈顶，这个时候，使用dirs -v查看目录栈中的目录会发现有当前目录，上一个目录和上上个目录。
pushd #将栈顶目录和栈顶下一个位置目录交换，同时切换到那个目录，由于栈顶下一个位置存放的是跳转而来的目录，所以相当于执行了"cd -"
pushd +n #切换到目录栈中任意一个目录，这里的"n"对应的是"dirs -v"中的目录序号
popd #将目录栈中的栈顶元素出栈，栈顶下一个位置的目录变成栈顶，所以会切换到那个目录
popd +n #将目录栈中的第n个元素删除
```
实际上pushd和popd除了能使用+n作为参数之外还能用-n作为参数，区别在于+n表示从栈顶向下数，-n表示从栈底向上数。  
**使用示例:**
```txt
$ dirs -v
~
~/downloads/
$ pushd ~/workspace/
**常见用法：**  
$ dirs -v
0	~
1	~/foo
$ pushd ~/bar
~/bar ~ ~/foo
$ dirs -v
0	~/bar
1	~
2	~/foo
$ popd
~ ~/foo
$ dirs -v
0	~
1	~/foo   
```
### ls
**作用:**  
显示当前目录下文件   
**语法:**  
```bash
ls [options] [dirName]
```
**常见用法：**  
```bash
ls #列出文件和目录
ls -l #以列的形式展示当前目录下文件，包含文件或者目录，读写执行权限，拥有者，群组，大小，修改时间等信息
ls -a #同时显示以"."开头隐藏的文件和目录
ls -ltr #l表示列表显示，t表示按照时间顺序排列文件及目录，r表示倒序。所以会由新到旧显示当前目录下文件
ls -R #递归列出子目录
ls -lS #从大到小列出目录下文件
ls *sh #列出所有以"sh"结尾的文件
ls -1 #列出目录下的文件或目录,每行显示一个
```
通常会在~/.${SHELL}rc文件中设置ls的别名例如：
```txt
alias la='ls -al --color=auto'
alias ll='ls -l --color=auto'
```  
### tree
**作用:**  
以树状图的形式显示当前目录下文件及目录，适合全局总览目录内的文件  
**语法:**  
```bash
tree [options] [dirName]
```
**常见用法：**  
```bash
tree #以树状的形式列出当前目录下所有文件及目录
tree -d #仅显示目录名称，不显示内容
tree -L 3 #表示仅仅显示到第3层目录
tree -P "*.sh" #"-P"表示后面的参数是样本范式。这里只会显示后缀为".sh"的文件及目录
```
### pwd
**作用:**  
显示当前路径，pwd的含义是"print working directory"  
**语法:**  
```bash
pwd [options]
```
**常见用法：**  
```bash
pwd -P #使用实际路径，而非使用链接路径
pwd -L #使用环境中的路径，即使包含了符号链接
```
### cp
**作用:**  
将文件或者目录拷贝到新的目录下  
**语法:**  
```bash
cp [options] <src> <dst>
```
**常见用法：**  
```bash
cp -r ~/foo ~/bar #在拷贝目录时需要使用"-r"参数表示递归拷贝目录下所有文件。如果bar目录存在，则会将foo复制到bar目录下；否则会将foo复制到当前目录，并命名为bar
cp -f ~/foo ~/bar #强制复制，当在目标目录中发现同名文件强制覆盖原文件
cp -s ~/foo ~/bar #复制成原文件的软链接
```
### mv
**作用:**  
移动或重命名文件或文件夹  
**语法:**  
```bash
mv [options] <src> <dst>
```
**常见用法：**  
```bash
mv test.jpg test2.jpg test3.jpg ~/Pictures #将多个jpg文件移动到~/Pictures/目录下
mv dir1/ dir2/ dir3/ #将dir1和dir2移动到dir3目录下，不需要带参数-r
mv test.jpg abc.jpg #mv的另一个重要功能是重命名文件。将test.jpg重命名为abc.jpg
mv -v * ~/ #当移动一个大文件或者目录时，会想知道操作是否成功，使用-v选项会返回操作成功结果
mv -i test.txt ~/ #当移动一个文件到新的目录时，如果目标目录已经有了一个同名文件，mv默认会覆盖文件，不给任何提示信息。-i选项在出现目标目录包含同名文件时会提示是否覆盖
```
### ln
**作用:**  
建立文件的同步链接  
**硬链接与软链接的区别:**  
我们都知道文件都有文件名和数据，这在Linux上被分为两个部分：用户数据与元数据。用户数据即文件数据块是记录文件真实内容的地方；而元数据是文件的附加属性，如文件大小、创建时间、所有者等信息。元数据中的inode号才是文件的唯一标识而非文件名。  
如果一个inode号对应多个文件名，则称这些文件为硬链接。换言之，硬链接就是同一个文件使用了多个别名。由于硬链接是有着相同inode的不同文件，所以硬链接具有以下特性：  
- 文件具有相同的inode及data block；  
- 只能对已存在的文件进行创建；  
- 不能交叉文件系统进行硬链接创建；  
- 不能对目录进行创建，只能对文件进行创建，因为目录中的"."和".."都是硬链接，如果对目录创建硬链接将产生目录环；  
- 硬链接会使用i_nlink对持有相同inode的文件计数，删除一个硬链接文件并不影响其他有相同inode的文件,如果计数变为0，则用户数据被删除。  

若文件用户数据块中存放的内容是另一个文件路径名的指向，则该文件就是软链接。软链接就是一个普通文件，只是数据块内容比较特殊。软链接具有自己的inode号及用户数据块。因此软链接没有类似硬链接的诸多限制：  
- 软链接有自己的文件属性及权限等；  
- 可对不存在的文件或者目录创建软链接；  
- 软链接可交叉文件系统； 
- 软链接可对文件或目录创建； 
- 创建软链接时，链接数i_nlink不会增加；  
- 删除软链接并不影响被指向文件，但如果原文件被删除，相关软链接无法使用，被称为死链接。  

**语法:**  
```bash
ln [options] <src> <dst>
```
**常见用法：**  
```bash
ln -s souce destiny #创建source的软链接，名为destiny
ln source destiny #创建source的硬链接，名为destiny
```
**使用示例：**  
```txt
$ touch a.txt %% echo "hello" > a.txt #创建一个文件a.txt
$ ln a.txt b.txt # 创建a.txt的硬链接b.txt
$ ln -s a.txt c.txt # 创建a.txt的软链接c.txt
$ ls -ail *.txt #显示.txt格式的文件详细信息及inode号,可以看到硬链接的inode与原文件相同，而软链接的文件格式为l，且文件大小与原文件不同。
28360758 -rw-rw-r-- 2 heliwei heliwei 6 Nov 27 17:50 a.txt
28360758 -rw-rw-r-- 2 heliwei heliwei 6 Nov 27 17:50 b.txt
28999817 lrwxrwxrwx 1 heliwei heliwei 5 Nov 27 17:50 c.txt -> a.txt
```
### mkdir
**作用:**  
创建新目录  
**语法:**  
```bash
mkdir [options] <dirName>
```
**常见用法：**  
```bash
mkdir foo #创建名为foo的文件夹
mkdir -p foo/bar #-p参数表示如果建立目录的上层目录foo尚未建立，则会建立上层目录。
```
### touch
**作用:**  
创建空文件或修改文件的时间戳。cat常用于创建简单的有字符的文件，而touch通常创建空文件  
**语法:**  
```bash
touch <fileName>...
```
**常见用法：**  
```bash
touch {log1, log2, log3}.txt #创建名为log1.txt log2.txt和log3.txt的文件  
touch -t 201912011200 log.txt #修改log.txt的Access和Modify时间戳
```
Access time, Modify time的介绍见 [stat命令中关于系统时间的介绍]( ###stat )
### rm
**作用:**  
删除文件或目录  
**语法:**  
```bash
rm [options] <name>...
```
**常见用法：**  
```bash
rm -rf ./dir/ #-r表示会递归删除目录dir下的所有子目录，-f表示若遇到文件为只读权限时不提示信息直接删除
rm -vi ./dir/ #-v表示会显示详细的步骤，-i表示任何删除操作之前都必须先确认
```
使用"rm -rf"后面带有一个变量表示的目录时需要格外小心，因为如果变量没有定义就会直接删除根目录
```bash
rm -rf ${dir}/ #若dir为定义，则删除系统根目录
rm -rf ${dir:?"undefined 'dir'"} #若dir为定义，则报错
```
### file
**作用:**  
用于辨识文件类型  
**语法:**  
```bash
file [options] <name>...
```
**常见用法：**  
```bash
file a.txt #会返回a.txt的文件类型ASCII text
file -L c.txt #直接显示符号连接所指向文件的类别
file -z a.zip #-z参数表示尝试去解读压缩文件的内容
```
### stat
**作用:**  
显示文件详细信息  
**语法:**  
```bash
stat [options] <file>...
```
**使用示例：**  
```bash
$ stat -c'%i | %s' a.txt #-c后面接格式化的内容，%i表示文件的inode，%s表示文件有多少bytes 
28360758 | 6 #显示a.txt的所有信息。当读文件时Access时间会改变；修改文件时Access，Modify，和Change都会改变；修改文件属性时，如chmod,chown,create,mv只有Change会改变。links表示有两个文件的inode一致
$ stat a.txt
File: 'a.txt'
size: 6               Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 28360758    Links: 2
Access: (0664/-rw-rw-r--)  Uid: (11637/ heliwei)   Gid: (11637/ heliwei)
Access: 2019-11-27 18:10:51.490498640 +0800
Modify: 2019-11-27 17:50:30.016255545 +0800
Change: 2019-11-27 18:31:30.005907580 +0800
 Birth: -
```
### md5sum
**作用:**  
计算文件的MD5哈希值，通常用来校验文件是否一样  
**语法:**  
```bash
md5sum [options] <fileName>...
```
**常见用法：**  
```bash
md5sum a.txt #获取a.txt的MD5哈希值
md5sum *.txt >a.md5 #将所有txt格式文件的md5值写入a.md5文件中
md5sum -c a.md5 #-c后面的参数是md5值，如果该目录下有文件的md5值与之相同，则会输出那个文件，通常用于校验文件是否正常下载。如果在命令行中使用这个命令需要通过"$?"获取返回值来确定是否匹配成功
```
### chmod
**作用:**  
修改文件的权限  
Linux/Unix的文件调用权限分为三级：文件拥有者、群组、其他。  
**语法:**  
```bash
chmod [options] <mode> <file>...
```
mode是权限设定字符串，其格式如下：
```txt
{u|g|o|a}[{+|-|=}{r|w|x}]...
```
u表示文件的拥有者，g表示与文件拥有者属于相同群组的用户，o表示其他用户，a表示对所有人  
+表示增加权限、-表示取消权限、=表示唯一设定权限    
r表示读取权限、w表示写入权限、x表示可执行权限  
**常见用法：**  
```bash
chmod u+x run.sh #给文件的所有者添加"run.sh"的执行权限
chmod 744 run.sh #744三位数字分别表示文件所有者、相同群组用户、和其他人的权限。可读、可写、可执行分别表示二进制数的三位。所以7（111）表示文件所有者具有读写执行的权限，4(100)表示同组用户只有读权限。
chmod -R 777 ./dir #-R表示为目录递归更改权限
```
### chgrp/chown
**作用:**  
chgrp 修改文件的群组  
chown 修改文件的拥有者  
**语法:**  
```bash
chgrp [options] <Group> {File | Directory}...  
chown [options] <Owner [:Group]> {File | Directory}...
```
**常见用法：**  
```bash
sudo chown foo a.txt #将a.txt文件的所有者修改为foo，由于文件原所有者是root，所以需要sudo来获取root权限
sudo chown -R --reference=a.txt ./dir/ #-R表示递归修改目录下文件所有者，--reference表示修改后的所有者属性参照a.txt文件。
chgrp -R --reference=a.txt ./dir/ #表示递归修改"dir"下文件所属群组，群组属性参照a.txt文件
```
### tar
**作用:**  
tar 是linux中最常用的解压缩命令。tar命令可以用于处理后缀名为tar,tar.gz,tgz,tar.Z,tar.bz2的文件
切换目录  
**语法:**  
```bash
tar [options] <commpressedFile> <originFile>...
```
**常见用法：**  
```bash
tar -zcvf test.tar.gz file1 file2 #打包，并以gzip压缩
tar -jcvf test.tar.bz2 file1 file2 #打包，并以bzip2压缩
tar -cvf test.tar file1 file2 #将file1和file2归档，但不压缩
tar -tvf test.tar #查看test.tar中包含哪些文件
tar -xvf test.tar #解压test.tar到当前目录
tar -xvf test.tar -C ./dir #解压test.tar到指定目录
```
**上述参数含义:**  
-z 或 --gzip 或 --ungzip 通过gzip指令处理备份文件  
-j 使用bzip2处理备份文件
-c 或 --create 建立新的备份文件  
-v 或 --verbose 显示执行详细过程  
-f<file> 或 --file=<file> 指定备份文件  
-t 列出备份文件中的内容
-x 或 --extract 或 --get 从备份文件中还原文件  
### zip/unzip
**作用:**  
zip和unzip命令主要用于处理zip包  
**语法:**  
```bash
zip [options] {file | directory}...
unzip [options] <file>...
```
**常见用法：**  
```bash
zip -r test.zip test/ #打包test目录下的文件
zip -rj test.zip test/ #打包test目录下的文件，且压缩包不带test目录
zip -r test.zip test/ -P 12345 #设置解压密码为12345
unzip -l test.zip #查看压缩包中的文件名，日期等信息
unzip -v test.zip #查看更多的信息，例如crc校验信息等
unzip -oj test.zip -d dir #将test.zip解压到dir目录。-j表示解压文件不包含文件目录名，只包含其中文件
```
**上述参数含义：**  
zip:  
-r 递归处理，将指定目录下所有文件和子目录一并处理  
-j 只保留文件名及其内容，而不存放任何目录名称  
-P \<password\> 压缩时设置密码  
unzip:  
-l 显示压缩文件内包含的文件  
-v 执行时显示详细的信息  
-o 不必询问用户，unzip执行后覆盖原有文件  
-j 不处理压缩文件中原有的目录路径  
-d \<dir\> 指定文件解压缩后要存储的目录  

解压和压缩还有gzip,bzip2,rar,unrar等命令  
### diff
**作用:**  
diff是Unix系统的一个很重要的工具程序，它用来比较两个文本文件的差异，是代码管理的基石之一。   
**语法:**  
```bash
diff [options] <file1> <file2>
```
**使用示例：**  
```txt
$ echo "a\na\na\n" > a.txt
$ echo "a\na\nb\nc\n" > b.txt #创建文件a.txt,b.txt
$ diff a.txt b.txt #正常模式下的diff
3c3,4
< a
---
> b
> c

$ #上面结果的第一部分是3c3,4中第一个3表示a.txt第3行，"3,4"表示b.txt中的3到4行。
$ #c表示修改(change)还有a(addtion),d(deletion)
$ #"<a" 表示a.txt中不同的内容，">b"和">c"表示b.txt中不同的内容。"---"表示两个文件的分隔符
$ diff -c a.txt b.txt #-c 表示显示上下文模式的diff
  tmp diff a.txt b.txt -c
*** a.txt       2019-11-28 20:47:17.559415446 +0800
--- b.txt       2019-11-28 20:47:58.015557214 +0800
***************
*** 1,3 ****
  a
  a
! a
--- 1,4 ----
  a
  a
! b
! c

$ #第一部分的两行显示来两个文件的基本信息，文件名及时间  
$ #"***"表示变动前的文件，"---"表示变动后的文件
$ #一般会显示变动部分及其前后三行，'!'表示改动，'+'表示增加,'-'表示减少
$ diff -u a.txt b.txt #-u表示合并格式的diff
--- a.txt       2019-11-28 20:47:17.559415446 +0800
+++ b.txt       2019-11-28 20:47:58.015557214 +0800
@@ -1,3 +1,4 @@
 a
 a
-a
+b
+c
$ #第一部分是文件基本信息,"---"表示变动前的文件，"+++"表示变动后的文件
$ # "@@ -1,3 +1,4@@"表示原文件1到3行，修改后文件1到4行的内容对比
$ # 最后部分中'-'表示第一个文件中减少的行，'+'表示第二个文件中增加的行
```
### cmp
**作用:**  
diff用来对比文本文件，但涉及到对比二进制文件是否相同，除了用md5sum之外，还可以用cmp  
**语法:**  
```bash
cmp [options] <file1> <file2>
```
**常见用法：**  
```bash
cmp -l prog.o.bak prog.o #对比两个二进制文件，-l的含义是显示十进制的字节数和八进制的不同字节
cmp -s prog.o.bak prog.o #-s的含义是只返回退出值，0表示相同的文件，1表示不同的文件，>1表示发生错误
```

## 2. 输入及输出操作
### echo
**作用:**  
输出内容到标准输出流    
**语法:**  
```bash
echo [options] <contents>...
```
**常见用法:**  
```bash
echo "hello world." > a.txt #将STDOUT的输出重定向至a.txt文件中
echo "shell is $SHELL" #通过'$'显示变量，打印出当前的shell
echo -e "\"OK \"\n" #-e表示开启转义，使用'\'来转义
echo `date` #输出date的内容
echo -n "Would not go to next line." #echo默认会换行，-n表示不换行
```
在脚本文件中，常常通过颜色定义让脚本输出更具辨识度  
```bash
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
function red(){
	echo -e "$RED$*$NORMAL"
}
function green(){
	echo -e "$GREEN$*$NORMAL"
}
function yellow() {
	echo -e "$YELLOW$*$NORMAL"
}
# To print success
green "Task has been completed"
# To print error
red "The configuration file does not exist"
# To print warning
yellow "You have to use higher version"
```
可以设置仅仅当设置了DEBUG标志位才打印调试信息，来区分log的层级
```bash
function debug() { ((DEBUG)) && echo ">>> $*"; }
```
上面的&&前面若为真则需要判断第二个参数，所以执行echo语句，如果第一个参数为假，求与表达式被短路，不会执行echo语句  
### printf
**作用:**  
printf是模仿C程序库中printf()的程序    
**语法:**  
```bash
printf <format-string> [arugments]...
```
format-string为格式控制字符串，argument为参数列表  
**常见用法:**  
```bash
printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543 
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876 
```
上面%-10s表示宽度为10个字符，'-'表示左对齐，没有则表示右对齐，%4.2f指格式化为小数，其中.2表示保留2位小数,除了上述用到的格式化符号外还有%d表示是整数  
### read
**作用:**  
接收标准输入的输入或其他文件描述符的输入，得到输入后，将数据放入一个标准变量中    
**语法:**  
```bash
read [options] <name>...
```
**常见用法:**  
```bash
echo "enter your name"
read name
echo "your name is ${name}" #将输入存入变量name中

read -s password #-s表示不在屏幕上显示输入的内容，常用于输入密码

READ_TIMEOUT=60
read -t "$READ_TIMEOUT" input #为输入设置过期时间

count = 1
cat test | while read line
do
	echo "Line $count:$line"
	count=$[$count + 1]
done
echo "finish"
exit 0 #通过管道读取文件汇总的内容,每次读取一行
```
### head/tail
**作用:**  
head 将一段文本或者管道输入的最前面一部分输出到标准输出    
tail 将一段文本或者管道输入的最后面一部分输出到标准输出    
**语法:**  
```bash
head [options] [file]...
tail [options] [file]...
```
**常见用法:**  
```bash
head a.txt -n 5 #打印出a.txt中的前5行,-n表示打印的行数, 默认打印10行
tail a.txt -c 10 #打印出a.txt中最后10个字符

tr A-Z a-z |					#大小写转换
	sort |						#按文本排序
		uniq -c |				#去除重复的选项并显示重复出现的次数 -c表示显示重复次数
			sort -k1nr -k2 |	#字符串以空格分成域，以第一个排序，在按第二个排序k1指第一个域，-n按数字大小排序，-r排序结果逆向显示
				head -n $count	#显示词频最高的前count个单词

history | tail -n 10 #查看最近使用的10个命令  
```
### vi/vim
**作用:**  
查看或编辑文本文件  
**语法:**  
```bash
vi [options] [file-name]...
```
**常见用法：**  
```bash
vi +10 a.txt #打开a.txt并将光标置于第10行行首
vi +/cout*  a.txt #打开a.txt并将光标移动到第一个cout之处
```
**编辑方法：**
- h 左移动一个字符
- l 右移动一个字符
- j 下移动一个字符
- k 上移动一个字符
- 0 移动至行首
- ^ 移动至行首
- $ 移动至行尾
- G 移动至最后一行行首
- gg 移动至第一行行首
- f/F 向后/向前搜索一个字符，并跳转到第一个匹配项
- ; 重复f/F搜索操作
- /\<abc\>\C 搜索文本中完全匹配abc的内容,\C表示区分大小写
- n 移动至下一个匹配处
- N 移动至上一个匹配处
- i 光标之前插入
- a 光标之后插入
- o 换行后插入
- x 删除一个字符
- dd 删除一行
- s 删除一个字符并切换到插入模式
- r 替换一个字符
- . 重复修改操作
- v 进入到Visual模式
- : 进入到命令模式
- :wq! 强制保存文件并退出
- :%s/abc\*/ddd/gc 替换abc开头的文本为ddd
- :reg 查看寄存器中的内容，使用<寄存器>+y可以粘贴到文本中
- :set number 让文本左边显示行号，可以在vimrc中加上这句以永久显示行号
- qa <operations> q , @a 录制<opreations>操作，放入a寄存器中，@a表示重复录制的操作
- y/p yy/pp 复制,粘贴。重复的使用总是表示对一行进行操作，所以yy/pp表示复制一行/粘贴一行
- "+y "+p "寄存器表示系统剪切板,所以"+y/"+p表示复制或粘贴系统剪切板中的内容，这样也可以粘贴复制其他寄存器
- u/Ctrl + r 撤销上一个操作，重复上一个操作
- == 格式化一行内容
- Ctrl + v 进入列编辑模式，配合大写I可以同时对多行进行插入
- \<\< \>\> 向左/右移动一个制表符

### cat
**作用:**  
切换目录  
**语法:**  
```bash
cat [options] [>] <fileName>... [<<EOF]
```
**常见用法：**  
如果用echo显示脚本用法，当文字较多时，echo语句条理将变得混乱，一个比较好的方法是使用cat来代替  
```bash
cat<<EOF
Usage: myscript <command> <arguments>
Version: 1.0
Available Commands
	install -
EOF
```
这里的<<称为here document，可以将字符串防止在两个EOF之间，这里的EOF也可以用其他的标志代替。这种方法同时可以应用到向文件中写入的操作
```bash
$ cat > ~/a.cpp <<EOF
> #include <iostream>
> using namespace std;
> EOF
```
更简单的方法是使用cat\>file来向文件中写入，只是需要使用Ctrl+c或者Ctrl+d来结束输入
cat也可以用于将一个文件的内容输出到另一个文件 `cat -n file2 > file2` 将file1中的内容带上行号输入到file2中 -n表示统计行号  
### dirname/basename
**语法：**  
```bash
dirname <filename>
basename <filename> [suffix]
```
**作用：**  
dirname 用于在路径及文件名字符串中获取目录名  
basename 用于去掉文件的目录
**常见用法：**
```bash
cd $(dirname $0) || exit 1
```
通常在脚本的开头会调用这个语句来保证不管使用者在哪个目录下调用这个脚本，脚本内的语句都是以脚本所在目录为起始点。其中"$0"表示脚本的路径及名字的字符串  
```bash
basename ~/path/a.cpp .cpp #去掉目录名称及.cpp后缀
echo "NAME: $(basename $0)" #输出脚本文件的名称，可以在文件头中文件说明使用
```
### cut
**作用：**  
cut命令主要作用是纵向截取列表内容，获取列表的某些列。  
**语法:**  
```bash
cut [options] <arugments>
```
使用示例：**
```bash
$ cat table.txt
name age height
tom 12 120
jerry 11 115
$ cut -c 1-4 table.txt #输出table.txt以字符为单位进行分割的第1-4列
name
tom 
jerr
$ cut -b 1,3,6 table.txt #输出table.txt以字符为单位，但忽略多字节字符边界的1,3,6列,与-的差别主要在中文的使用上 
nma
tm0
jr 
$ cat table1.txt
name,age,height
tom,12,120
jerry,11,115
$ cut -d ',' -f 1,2 table1.txt #以','为分隔符，打印数据的第1和第2列。-d表示指定分隔符，默认分隔符为空格或tab，-f表示显示第几块区域
name,age
tom,10
jerry,12
$ who | cut -b 34-38 | sort #通过管道，截取输出值中希望用到的值
14:36
14:37
17:21
$ cut table1.txt -f 1-3 | tail -n 2 | sort -k2nr -k3nr #将最后两行表格内容按照年龄倒序，身高倒序排序
jerry,12,120
tom,10,130
```
### paste
**作用：**  
将两个文本横向拼接到一起  
**语法:**  
```bash
paste [options]... [files]...
```
**使用示例：**
```bash
$ cat table1.txt
name age
tom 10
jerry 11
$ cat table2.txt
height
120
110
$ paste table1.txt table2.txt > table.txt && cat table.txt
name age height
tom 10 120
jerry 11 110
$ paste table2.txt table2.txt -d: -s > table.txt && cat table.txt #-d表示指定冒号为输出的分隔符,-s表示将每个文件进行平铺显示
name age: tom 10: jerry 11
height:120:110
ls | paste #作用等同于ls -1 将ls的输出每个占一行显示
```
### wc
**作用：**  
用于计算数量,可以是文件的byte数、字数或者行数  
**语法:**  
```bash
wc [options] [file]...
```
**使用示例：**
```bash
$ cat log.txt
name age height
tom 10	120
jerry 11 110
$ wc -l log.txt #-l表示统计文件行数
3 log.txt
$ wc -c log.txt #-c表示显示Bytes数
40 table.txt
$ ls | wc -l #统计文件夹下有多少文件
$ cat log.txt | egrep "120" | wc -l #统计文件中出现了多少次120
```
### yes
**作用：**  
用于连续输出字符，如果没有指定则输出y  
**语法:**  
```bash
yes [string]
```
**常见用法：**
```bash
yes "hello" #连续输出"hello"字符
```
另一个常见的场景是:当需要删除的文件夹下有大量没有写权限的文件，删除时会不断弹出询问语句，这是可以用yes代替手动不断输入。这一点rm加上-f参数也能做到
```bash
yes | rm -r /tmp
```
## 3. 进程及系统信息管理
### ps
**作用:**  
ps是process status的缩写，用于显示瞬间进程的动态  
**语法:**  
```bash
ps [options]
```
**参数解释：**  
```txt
-A 列出所有的进程
-w 加宽显示，显示较多的信息
-au 显示详细资讯
-aux 显示包含其他使用者的进程
```
**表头含义：**  
- USER 进程拥有者
- PID 进程ID
- %CPU 占有的CPU使用率
- %MEM 占用的内存使用率
- VSZ 占用的虚拟内存大小
- RSS 驻留空间的大小。显示当前常驻内存空间的程序的K字节数 
- TTY 进程相关的终端
- STAT 进程状态，其代码的含义为：
	- D 不可中断
	- R 正在运行或者在队列中的进程
	- S 处于休眠状态
	- T 停止或被追踪
	- Z 僵尸进程
	- W 进入内存交换
	- X 死掉的进程
	- < 高优先级
	- N 低优先级
	- L 有些页被锁进内存
	- s 包含子进程
	- \+ 位于后台的进程组
	- ｜多线程克隆线程
- TIME 进程使用总CPU时间
- COMMAND 被执行的命令行
### top
**作用:**  
top是Linux下常用的性能分析工具，能够实时显示系统中各个进程的资源占用情况，类似与Windows任务管理器  
**语法:**  
```bash
top [options]
```
**常用参数：**  
- -p\<PID\> 指定进程
- -n\<num\> 循环显示num次
- -u\<UserName\> 指定用户名 
- -i\<time\> 设置间隔时间
- -S 积累模式  
**输出信息：**  
```txt
top - 21:54:01 up 69 days,  4:03, 60 users,  load average: 0.00, 0.00, 0.00
Tasks: 115 total,   1 running, 109 sleeping,   3 stopped,   1 zombie
%Cpu(s):  0.1 us,  0.1 sy,  0.0 ni, 99.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 16483236 total,  1723296 free,  1577692 used, 13182248 buff/cache
KiB Swap:        0 total,        0 free,        0 used. 13593748 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
10642 heliwei   20   0  979660 132688  29768 S   0.3  0.8  50:00.94 node
60224 heliwei   20   0  617564  56584  29600 S   0.3  0.3  36:01.96 node
    1 root      20   0   37284   3644   2372 S   0.0  0.0   0:31.97 systemd
   29 root      20   0   43468  10408  10096 S   0.0  0.1   0:17.13 systemd-jo+
   47 root      20   0   23536    204      0 S   0.0  0.0   0:00.00 rpc.idmapd
```
- 第一行：任务队列信息，同uptime命令执行结果  
`21:54:01` 当前系统时间  
`up 69 days` 系统运行时间  
`60 users` 当前登录用户数  
`load average: 0.00, 0.00, 0.00` 系统的平均负载数
- 第二行：进程统计信息
`Tasks: 115 total` 系统当前总进程总数  
`1 running` 正在运行的进程数  
`109 sleeping` 睡眠进程数  
`3 stopped` 停止进程数  
`1 zombie` 僵尸进程数
- 第三行：CPU统计信息
`0.1 us` 用户空间cpu占用率  
`0.1 sy` 内核空间cpu占用率  
`0.0 ni` 用户进程空间改变优先级的进程cpu的占用率  
`99.8 id` 空闲cpu占用率  
`0.0 wa` 等待输出输出的cpu时间百分比  
`0.0 hi` 硬件中断请求  
`0.0 si` 软件中断请求  
`0.0 st` 分配给运行在其他虚拟机上的任务的实际cpu时间  
- 第四行：内存状态
`KiB Mem : 16483236 total` 物理内存重量16G  
`1723296 free` 空闲内存  
`1577692 used` 已用内存  
`13182248 buff/cache` 缓冲交换区  
- 第五行：swap交换分区信息
`KiB Swap:        0 total` 交换区总量  
`0 free` 空闲交换分区  
`0 used` 已使用交换分区内存  
`13593748 avail Mem` 缓冲交换区
- 第六行及以下：进程信息
	- PID 进程ID
	- USER 进程所有者的用户名  
	- PR 进程优先级  
	- NI nice值，负值表示高优先级，正值表示低优先级
	- VIRT 进程使用的虚拟内存总量 VIRT=SWAP+RES  
	- RES 进程使用的未被换出的物理内存大小  
	- SHR 共享内存大小  
	- S 进程状态，D:不可中断的睡眠状态，S:睡眠，T:跟踪停止, Z：僵尸进程 
	- %CPU 上次更新到现在的CPU时间占用百分比  
	- %MEM 进程使用的物理内存百分比
	- TIME+ 进程使用的CPU时间总计，单位1/100秒
	- COMMAND 进程名称/命令行    

**命令运行中的操作:**
- 1 按数字'1'可以打开或者关闭显示单个cpu的统计信息
- B 打开或关闭当前进程显示效果
- shift + \> \/ \< 进程列表默认是按照CPU使用率进行排序，如果想按照其他列进行排序可以使用"shift + \>"或"shift + \<"进行切换

### kill
**作用:**  
切换目录  
**语法:**  
```bash
```
### free
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### time
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### date
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### history
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
!53 #运行历史记录中标号为53的命令
!! #运行最后一条命令  
```
### ping
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### ip
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### which
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### whereis
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### whoami
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### id
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### uname
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### who
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### exit
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### shutdown
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### sleep
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### df
**作用:**  
切换目录  
**语法:**  
```bash
```
### du
**作用:**  
切换目录  
**语法:**  
```bash
```

**常见用法：**  
```bash
```
### export
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```
### source
**作用:**  
切换目录  
**语法:**  
```bash
```
**常见用法：**  
```bash
```

---

# 二、进阶命令
### &/|/!/\#/$
### grep
### find
### sed
### awk
### perl
### xargs
### git
### ssh
### tmux
### watch
### if/else
### for
### while
### Shortcuts
Linux终端内置了一些快捷键操作，大大增加了命令输入修改的效率  
- Ctrl + n: 显示下一个命令，oh-my-zsh中方向键下有相同功能
- Ctrl + p: 显示上一个命令
- Ctrl + r: 反向搜索历史记录
- Ctrl + q: 在Ctrl + s之后重新恢复之前的terminal
- Ctrl + a: 光标移动到行首
- Ctrl + e: 光标移动到行尾
- Ctrl + c: 发SIGINT信号给前台进程组中的所有进程，强制终止程序执行  
- Ctrl + z: 发送SIGTSTP信号给前台进程组中的所有进程，常用于挂起一个进程，并非结束进程，用户可以使用fg/bg操作恢复执行前台或后台的进程。fg命令在前台恢复执行被挂起的进程，此时可以用Ctrl+z再次挂起该进程，bg命令在后台恢复执行被挂起的进程，而此时不能使用Ctrl+z再次挂起
- Ctrl + d: 表示EOF，相当于在终端中输入exit后回车，一般用在结束一串输入，比如cat>a.txt。也用于例如从管理员权限退出的场景
- Ctrl + s: 终端停止输出（如apt/yum,nload, watch等，按Enter继续输出）
- Ctrl + l: 清屏，相当于clear命令
- Ctrl + w: 剪切光标之前的单词，然后Ctrl + y粘贴它
- Ctrl + u: 剪切光标之后的单词，然后Ctrl + y粘贴它
- Ctrl + k: 删除从当前光标到结尾的所有字符


### ${##%%}
### sort
### uniq
### tr
```bash
seq 100 | echo $[ $(tr '\n' '+') 0]
```
### set
```bash
set -e -o pipefail #在脚本开头写这句话，单行或者单行管道命令出现错误，脚本会停止执行并报错
# 效果等同于脚本开头"#! /bin/bash -e"
```
### eval
### curl
---

# 三、扩展命令
## Android Related
### adb
### addr2line
## ELF Related
### readelf
### nm
## oh-my-zsh plugin
###  z/j
## vim/nvim
---
# 四、Linux与MacOS常见差别
---
