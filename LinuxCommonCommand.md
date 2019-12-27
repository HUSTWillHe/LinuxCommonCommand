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

count=1
cat test | while read line
do
	echo "Line $count:$line"
	count=$[$count + 1]
done
echo "finish"
exit 0 #通过管道读取文件汇总的内容,每次读取一行
```
需要指出的是，上述最后一个例子中count的计数在循环结束之后并不会显示实际的行数，因为使用管道会开启一个新的子shell，而子shell对变量的更改并不会影响到父shell中变量的值。
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
### cat
**作用:**  
从文件或标准输入中读入内容，输出到文件或标准输出中  
**语法:**  
```bash
cat [options] 
```
**常见用法：**  
如果用echo显示脚本用法，当文字较多时，echo语句条理将变得混乱，一个比较好的方法是使用cat配合here-document来  
```bash
cat<<EOF
Usage: myscript <command> <arguments>
Version: 1.0
Available Commands
	install -...
	...
EOF

cat<<"EOF" #这里EOF上有引号，所以下面的USER变量不会被展开
hello $USER
EOF
```
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
$ cut -b 1,3,6 table.txt #输出table.txt以字符为单位，但忽略多字节字符边界的1,3,6列 
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
```
### sort
**作用：**  
对文件或者标准输入进行排序  
**语法:**  
```bash
sort [options] [file]
```
**使用示例：**
```bash
sort file.txt
ls | sort
```
最简单的使用例子如上。sort后面加文件将按照ASCII表对文件的每行进行排序。也可以直接对标准输入进行排序，常常配合管道使用，对一些命令的标准输出排序
```bash
echo "apple\nbanana\norange\napple" | sort -u  #去除重复出现的内容
echo "apple\nbanana\norange" | sort -r  #按照ASCII表降序排列
```
如果需要排序的输入中有大量重复的内容，但是只想要显示一次可以使用-u参数，重复出现的项将只显示一次  
如果想要以倒序的方式给内容排序可以使用-r参数
```bash
echo "15\n9\n20" | sort #与预想不符的数字排序
echo "15\n9\n20" | sort -n #按数字大小进行排序
```
sort默认的排序方式是按照ASCII进行的，所以会出现9排在15后面的情况。为了按照数字大小进行排序，可以使用-n参数
```bash
echo "apple\nbanana\napple\norange" > a.txt
sort a.txt > output.txt #将排序结果重定向到另一个文件中
sort a.txt > a.txt #本想将结果保留到本文件中，但这样做不成功
sort a.txt >> a.txt #在原文本最后添加排序结果
sort a.txt -o a.txt #将排序结果保留到原文件中
sort a.txt -o out.txt #将排序结果保留到out.txt中
```
如果想用重定向的方式将排序好的内容保留到原文件中，会丢失文件中的内容。如果使用'>>'的重定向方式，原本内容依然会保存。使用-o参数加原文件，可以将排序后的内容替换到原文件中。同样方式也可以将排序结果保留到其他文件中
```bash
echo "tom:18\njerry:19\nmike:15" | sort -n -t ":" -k 2 #根据年龄进行排序
```
如果想要针对一行中某列进行排序，可以使用-k n来实现，其中的n表示的是第几列。默认是以空格为列的分隔符。但是往往列之间的分隔符并不是空格，这种情况下可以使用-t参数来指定自己想用的空格符。
```bash
echo "tom:18:192cm\njerry:19:178cm\nmike:15:178cm" | sort -n -t ":" -k 3,3.3r -k 2 #按照身高降序和年龄升序进行排序
```
如果需要按照多个维度对列表中的内容进行排序，可以在sort命令中使用多个-k参数。使用逗号将起始和重点位置隔开。"-k 3,3.3"表示从第3列开始到第3列的第3个字符结束。如果某个排列需要逆序，则可以在其后面加r表示；同理如果某个排列需要按数字排序而其他不需要，则在那个-k参数后面加n。

### uniq
**作用：**
用于检查及删除文本文件中重复出现的列，常与sort命令组合使用  
**语法:**  
```bash
uniq [options] [inputFile] [outputFile]
```
**使用示例：**
```bash
$ echo "apple\nbanana\norange\napple" | sort | uniq #去除所有重复的内容并输出
apple
banana
orange

$ echo "apple\nbanana\norange\napple" | sort | uniq -d #-d参数表示输出所有有重复的内容
apple

$ echo "apple\nbanana\norange\napple" | sort | uniq -u #-u参数表示输出所有不重复的内容
banana
orange

$ echo "apple\nbanana\norange\napple" | sort | uniq -c #-c参数表示去除重复行的同时显示行出现的次数
2 apple
1 banana
1 orange
```
在某些情况下需要求出两个文件的交集并集或者差异，可以通过以下的方式
```bash
cat a | sort -u -o a #在原文件上去重
cat b | sort -u -o b #同上
cat a b | sort | uniq #求出a和b文件中的并集
cat a b | sort | uniq -d #求出a和b文件中的交集
cat a b | sort | uniq -u #求出a与b文件的差异
```
sort和uniq -c常常搭配使用来统计词频
```bash
history | tail -n 200 | awk {print $2} | uniq -c | sort -k 1,1nr | head -n 10 #统计最近200条命令中使用最多的10条
```
uniq -c会统计相同行出现的次数，根据出现的次数倒序排序便可以获取使用最多的10个命令
### tr
**作用：**  
用于删除文件中的字符或进行字符转换  
**语法:**  
```bash
tr [options] [string1] [string2]
```
**使用示例：**
```bash
echo -e "1\n\n2\n\n\n3\n" | tr -s '\n' #删除输入的空行，输出1\n2\n3
echo "Hellooo   Worlddd" | tr -s "[ od]" #删除重复出现的od字符和空格，输出Hello World
echo "Hello     World" | tr -s "[ ]" #将多个空格合并为一个空格
```
使用-s参数可以将指定删除重复出现的内容
```bash
echo "   Hello World   " | tr -d '[ \t]' #删除输入的空格，如果只需要删除行首或行尾的空格可以使用sed命令
echo "Hello124 World345" | tr -d '[a-zA-Z]' #将输入所有字母删除，将输出124 345
echo "Hello124 World345" | tr -d '[0-9]' #将输入所有数字删除，将输出Hello World
echo "1\n2\n3" | tr -d '\n' #将多行合并成一行
```
如果需要删除某个字符集中的内容，可以使用-t参数
```bash
echo "Hello World" | tr '[a-z]' '[A-Z]' #小写转大写，输出HELLO WORLD
echo "Hello World" | tr '[A-Z]' '[a-z]' #大写转小写，输出hello world
echo "Hello World" | tr '[a-zA-Z]' '[A-Za-z]' #大小写互相转换，输出hELLO wORLD
```
tr另一个重要的作用是用新的字符替换原始字符
```bash
seq 100 | echo $[ $(tr '\n' '+') 0] #计算1到100所有整数之和
```
通过将换行符转换为加号对所有输出的数字进行求和计算
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
**常见用法：**  
```bash
ps -A #列出所有的进程
ps -u heliwei #-u后面加用户名可以查找特定用户的进程
ps -au #显示详细资讯
ps -aux --sort -pcpu | less #如果希望按照CPU或内存两来筛选，这样就能找到哪个进程占用了资源，使用这个参数能看到性能相关更全面的信息。使用--sort命令按照cpu使用率排序，并用less显示出来。
ps -aux --sort +pmem | less #按照内存使用升序排序
ps -aux --sort -pcpu,+pmem | head -n 10 #按照cpu使用率降序，内存升序排序，并显示前10个结果
ps -f -C tmux #-C后面跟想找的进程名
ps -axjf #以树状结构显示进程，更优的做法是使用命令pstree
watch -n 1 'ps -aux --sort -pmem,-pcpu' #使用watch命令，每个1s调用ps命令，来动态查看进程信息
watch -n 1 'ps -aux -U heliwei --sort -pmem,-pcpu | head 20' #只查找用户名为heliwei的内存降序cpu降序的前20个进程
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

### kill/pkill/killall
**作用:**  
终止指定的进程，通常终止一个前台进程可用Ctrl+C，但是对于后台进程就必须用kill命令，我们需要先使用ps/pidof/pstree/top等工具获取进程PID，然后使用kill命令来杀掉该进程。kill命令是通过向进程发送指定的信号来结束相应进程的。在默认情况下，采用编号为15的TERM信号。TERM信号将终止所有不能捕获该信号的进程。对于哪些可以捕获该信号的进程就要用编号为9的kill信号，强行“杀掉”该进程。  
**语法:**  
```bash
kill [options] [pid]...
```
**常用信号含义：**

|代号|名称|内容|
|----|----|----|
|1	|SIGHUP		|启动被终止的程序，可让该进程重新读取自己的配置文件，类似重新启动|
|2	|SIGINT		|相当于Ctrl+c来终止一个进程的进行|
|9	|SIGKILL	|强制终止一个程序的进行，与SIGINT的主要区别在于SIGINT只能终止前台进程而SIGKILL不是。kill命令默认不带参数就是发送SIGTERM，让程序友好地退出|
|15	|SIGTERM	|以正常的方式来终止程序。与SIGKILL的区别在于SIGTERM可以被阻塞、处理或忽略，但是SIGKILL不可以|
|19	|SIGSTOP	|相当于在键盘输入Ctrl+z来暂停一个程序的进行|
**常见用法：**  
```bash
kill -l #列出所有信号名称
kill -l TERM #获取TERM信号对应的数值
kill 60222 #查找到进程对应的编号后杀掉进程 
kill -9 60222 #-9表示向进程发送SIGKILL信号，表示强制终端一个进程
kill -9 $(ps -ef | grep tom) #杀死用户tom进程
kill -u tom #作用同上 
ps aux | grep httpd | awk '{print $2}' | xargs kill -9 #杀死所有httpd创建的进程
pkill -9 httpd #作用同上
killall -9 httpd #作用同上
pgrep -l httpd #列出httpd产生的所有进程
```
### free
**作用:**  
free命令可以显示Linux系统中的空闲的，已用的物理内存及swap内存，及被使用的buffer。  
**语法:**  
```bash
free [options]
```
**常见用法：**  
```bash
free -b #以byte为单位显示内存使用情况，类似的用法还有-k(KB) -m(MB) -g(GB)
watch -n 1 -d free #动态显示内存使用情况，-d表示高亮变化部分
cat /proc/meminfo #如果需要获取更多与内存相关的信息，可以直接查看/proc/meminfo文件
```
**输出含义：**  
- total 物理内存大小总计（total=used+free）
- used 总计分配给缓存(包括buffers和cache)使用的数量，但其中可能部分缓存并未实际使用
- free 未被分配的内存
- shared 多个进程共享的内存总额
- buffers 系统分配但未被使用的buffer数量
- cached 系统分配但未被使用的cache数量
### time
**作用:**  
通常用于计算命令的执行时间   
**语法:**  
```bash
time [options] [command]
```
**使用示例：**  
```bash
$ time sleep 3
sleep 3  0.00s user 0.00s system 0% cpu 3.002 total
```
`0.00s user` 表示用户态cpu时间  
`0.00s system` 表示核心态cpu时间  
`0% cpu` cpu利用率  
`3.002 total` 整个运行耗时。可以理解为在sleep运行结束时系统时间减去开始运行时系统的时间  
以上三者的关系是：`%cpu_usage = (user_time + sys_time)/real_time*100%`
cpu处于核心态时，代码具有完全的不受任何限制的访问底层硬件的能力。可执行任意的CPU指令，访问任意的内存地址。内核台通常情况下都是为那些最底层的，由操作系统提供的，可信可靠的代码来运行。内核态的代码崩溃将是灾难性的，会影响到整个系统。  
cpu处于用户态时，代码不具备直接访问硬件或者访问内存的能力，而必须借助操作系统提供的可靠的，底层API来访问硬件或内存。由于这种隔离带来的保护作用，用户态的代码崩溃，系统是可以恢复的。我们大部分的代码是运行在用户态的。  
区分用户态和核心态目的是为了隔离保护，让系统更稳定。  
### date
**作用:**  
显示系统的日期和时间  
**语法:**  
```bash
date [options] [format]
```
**常见用法：**  
```bash
date -d '+5 day' #显示5天之后的日期时间 
date -d '1 month ago' #显示 一个月之前的日期时间
date -d 'last-sunday' #显示上一个周日的日期时间
date -d 'next-monday' #显示上一个周日的日期时间
date -d 'next-day' +%Y-%m-%d #以yyyy-mm-dd显示明天的日期时间
date -s 20221111 #设置日期
date -s 12:12:12 #设置时间
date -s "2012-12-12 12:12:12"
date +"%T" #只显示时间
date +"%F" #以yyyy-mm-dd显示日期
date +"%j" #显示今天是一年的第几天
```
### history
**作用:**  
查看历史命令  
**语法:**  
```bash
history [options]
```
**常见用法：**  
```bash
history -c #清除所有命令历史
history | tail -n 5 #查看最近5条命令
history -5 #查看最近5条命令
!53 #运行历史记录中标号为53的命令
!! #运行最后一条命令  
!5223:p #执行history中第5223条指令并显示命令语句
!cat #执行前面执行过的以cat为起始字符的命令  
history | grep ls | wc -l #查看用了多少次ls命令
^oldstring^newstring #将前一个命令oldstring部分修改为newstring并执行
find . -name "a.txt"
^a.txt^b.txt #回车后将会执行find . -name "b.txt"，不过如果shell配置有上方向键显示上一个命令，直接回到上一个命令在上面修改更直观.
history | awk '{print $2}' | sort | uniq -c | sort -k1,1nr| head -10 #查找历史命令中使用最多的10条命令
Ctrl + R #键入关键字搜索历史命令
Ctrl + p #向前翻历史命令
Ctrl + n #向后翻历史命令
```
### ping
**作用:**  
用于定位，测试网络问题，通过发送ICMP请求到指定的IP地址，并等待反馈    
**语法:**  
```bash
ping [options] <destination>
```
**常见用法：**  
```bash
ping -i 3 -s 1024 -t 255 -c 2  www.baidu.com #-i 3表示发送周期为3秒，-s 1024表示设置发送包的大小，-t 255 表示TTL(ICMP转发次数)为255， -c 2表示收到两次包后自动退出
```
### ip
**作用:**  
ip命令与ifconfig命令类似，功能更加强大，旨在取代后者。  
**语法:**  
```bash
ip [options] <object> {command | help}
```
**常见用法：**  
```bash
ip addr show #列出网卡的诸如IP地址，子网网络信息
```
### which/whereis
**作用:**  
which在PATH变量指定的路径中搜索某个系统命令的位置并返回第一个搜索结果，也就是说可以看到某个系统命令是否存在以及执行的到底是哪一个位置的命令。  
whereis指令会在特定目录中查找符合条件的文件，这些文件应属于原始代码、二进制文件或者帮助文件。  
**语法:**  
```bash
which <command>...
```
**常见用法：**  
```bash
which bash zsh #查看bash，zsh命令路径
whereis -b bash #查看bash二进制文件所在位置
whereis -m bash #查看bash说明文档所在位置
whereis -s bash #查看bash源代码文件，若不存在则不显示
```
### id
**作用:**  
id命令可以显示用户ID（UID）和组ID（GID）  
**语法:**  
```bash
id [options] [user]
```
**使用示例：**  
```txt
$ id
uid=11637(heliwei) gid=11637(heliwei) groups=11637(heliwei),27(sudo),44(video),11638(fuse
```
上面结果表示heliwei的UID为11637，GID为11637。这个群组下的成员包括heliwei,sudo,video,fuse  
```bash
id root #列出root用户的uid和gid
id -G #列出不同组的id，可以与/etc/group文件中的内容对比
```
### uname
**作用:**  
获取操作系统信息  
**语法:**  
```bash
uname [options]
```
**常见用法：**  
```bash
uname #如果在Linux下会输出Linux，在Macos下会输出Darwin
uname -a #显示所有的信息
uname -r #输出Linux的内核发行版本
uname -n #输出主机名称
if [[ `uname` == Linux ]]; then date -d "+1 month"; else date -v-1m; fi #因为date命令在Linux和MacOS下的形式有差别，所以用uname先判断当前是在Linux还是MacOS下，以实现跨平台的脚本
```
### who/whoami
**作用:**  
who显示系统中有哪些使用者在上面，包括使用者ID使用者终端机，上线时间，呆滞时间，CPU使用量，动作等等  
whoami 是who am i的简洁写法，显示当前用户名  
**语法:**  
```bash
who [options] [user]
whoami
```
**常见用法：**  
```bash
whoami #将输出当前用户名
who -b #显示系统启动时间
```
```txt
$ who 
heliwei  pts/0        2019-12-03 13:49 (10.124.133.37)
heliwei  pts/1        2019-12-03 11:24 (tmux(1255).%0)
heliwei  pts/2        2019-12-03 13:49 (tmux(1255).%1)
```
第一列显示用户名称  
第二列显示用户连接方式，tty表示用户直接连在电脑上，pts意味着远程连接  
第三列第四列表示日期和时间  
第五列显示用户登录的IP地址  

### exit
**作用:**  
退出当前shell，在shell脚本中可以终止当前脚本运行  
**语法:**  
```bash
exit [returnCode]
```
**常见用法：**  
```bash
exit 0 #退出并返回退出码，0表示成功，非0表示失败,2表示用法不当，127表示命令未找到，126表示不可执行
$? #获取上一条命令的返回码
cd $(dirname $0) || exit 1 #如果不能切换到脚本所在目录，反馈错误代码1
trap "rm -f tmpfile; echo Bye" EXIT #在脚本中，退出时删除临时文件，trap命令的作用是监听EXIT信号，当收到此信号之后执行command操作  
if [[ $? != 0 ]];then echo "Illeagle"; fi #检查上一个命令是否成功返回，若不成功输出提示
```
### shutdown/poweroff/reboot/halt
**作用:**  
关机重启或停止机器  
**语法:**  
```bash
shutdown [options]
poweroff [options]
reboot [options]
halt [options]
```
**常见用法：**  
```bash
sudo shutdown -h 8:30 #设置关机时间为八点半

sudo shutdown now #立即关机
sudo poweroff #立即关机
sudo reboot -p #立即关机
sudo halt -p #立即关机

sudo shutdown -r #关机后重启
sudo poweroff --reboot #关机后重启
sudo reboot #关机后重启
sudo halt --reboot #关机后重启

sudo poweroff --halt #停止机器
sudo halt #停止机器
sudo shutdown -H now #停止机器
sudo reboot --halt #停止机器

sudo shutdown -c #取消关机
```
### sleep
**作用:**  
将调用的进程挂起一段时间，在给定的时间内暂停命令的执行。常用于重试失败或者循环中。  
**语法:**  
```bash
sleep [--help] [--version] number[smhd]
```
**常见用法：**  
```bash
sleep 1m20s #暂停1分20秒，s表示秒，m表示分钟，h表示小时，d表示天
while :
do 
	if ping -c 1 www.baidu.com &> /dev/null
	then
		echo "network works."
		break
	fi
	sleep 5
done #每过5秒检查一次网络是否能连上
```
### df
**作用:**  
显示目前在Linux系统上的文件系统的磁盘使用情况  
**语法:**  
```bash
df [options] [file]...
```
**使用示例：**  
```txt
$ df -h #-h表示human readable 显示易读的内容
ystem      Size  Used Avail Use% Mounted on
/dev/vda         50G   44G  6.2G  88% /
rootfs          7.8G  381M  7.5G   5% /brainpp
tmpfs           7.9G  140K  7.9G   1% /run
tmpfs           7.9G   12M  7.9G   1% /tmp
share_dir        94G  667M   94G   1% /etc/hosts
devtmpfs        7.8G     0  7.8G   0% /dev
tmpfs           7.9G     0  7.9G   0% /dev/shm
/dev/sda        1.0T   56G  969G   6% /data
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           7.9G     0  7.9G   0% /sys/fs/cgroup
```
第一列表示文件系统对应的设备文件路径名（一般是硬盘上的分区）;第二列给出分区包行的数据块（1024字节），第三、四列分别表示已用的和可用的数据块的数目。
### du
**作用:**  
查看档案或者目录的磁盘使用空间  
**语法:**  
```bash
du [options] [directory]... 
```
**参数解释：**
- a
**使用示例：**  
```bash
du ./ #显示当前目录下文件大小
du -a #同时显示目录及文件
du -h ./a.txt #显示a.txt文件大小，-h的含义是human-readable，以易读的形式显示
du -c ./a.txt ./b.txt #显示多个文件或目录的大小并统计它们的总和
du -h --max-depth=1 #--maxdepth可以用来指定目录的层次，=1表示只显示当前路径下目录的大小
find . -type f | xargs -I{} du -d 0 -h {}; #递归列出当前目录下所有文件的大小
du /etc | sort -nr | more #对/etc目录下文件大小进行排序显示
```
### export/set
**作用:**  
设置或者显示环境变量  
如果不加export直接用`name=value`的形式赋值，这个变量并不会传递给子shell，因为这种方式并不会产生环境变量。  
执行一个脚本时，会先开启一个子shell环境，子shell会继承父shell所有环境变量，但结束时在子shell中定义的环境变量并不能返回给父shell。  
比较常见的环境变量如PATH。"/bin","/sbin","/usr/bin","/usr/sbin","/usr/local/bin"等路径在系统环境变量中，如果可执行文件在这几个标准位置，在终端命令行输入该软件可执行文件的文件名和参数即可执行。  
如果指令的执行文件不在上述目录中可以使用`export $PATH=$PATH:路径`来实现增加新路径到环境变量。如果想要修改永久生效，可以将它写入到/etc/profile或者用户祝目录下的.bashrc文件中。前者对所有用户生效，后者只对该用户生效  
**语法:**  
```bash
export [options] [<name> = <value>]...
```
**常见用法：**  
```bash
export -p #列出所有shell赋予程序的环境变量
export -n BIN_UTILS #-n表示删除环境变量,变量实际上未删除，只是不在后续指令环境中  
export PATH=${PATH}:${GRADLE_HOME}:${NDK_HOME} #将GRADLE_HOME和NDK_HOME添加到环境变量中,可以将这条语句写入到`/etc/profile`或`.bashrc`中。
```
### source
**作用:**  
在当前shell中读取并执行文件中的命令  
当我们执行一个脚本的时候，是在终端的shell中fork一个子shell然后执行的，执行之后再返回原shell，如果在子shell中设置了某个环境变量，并不会在父shell中生效。使用source或者dot(.)明确告诉shell不要fork执行脚本，而是在当前shell执行，这样修改的环境变量就保存下来了。
**语法:**  
```bash
source <fileName>
```
**常见用法：**  
```bash
sh run.sh #通过这种方式或者使用路径加脚本名方式执行一个脚本会重新建立一个子shell，在子shell里面执行脚本中的语句，该子shell继承父shell的环境变量，但子shell新建的，改变的变量不会返回父shell
source environment.sh #这个命令只是简单地抽取脚本中的语句，依次在shell中执行，没有建立新的shell。脚本里面所有新建、改变变量的语句都会保存在当前shell里面
. newJob.env #作用同上
```
---

# 二、进阶命令
### 通配符与正则表达式  
通配符也叫文件名替换，它主要作用于匹配文件名，常用的命令是ls，find，cp，mv，case；正则表达式主要作用于匹配文件中的字符串，常用的命令是grep，awk，sed。  
#### 通配符
- \*	匹配零或多个任意字符  
- ?		匹配任意单个字符  
- []	指定中括号内的多个字符，如[rwx]或[r,w,x]表示r或w或x
- [^]或[!]	除了中括号内的字符外匹配任意一个字符
- [:digit:]	匹配任意一个数字
- [:lower:]	匹配任意一个小写字符
- [:upper:]	匹配任意一个大写字符
- [:alpha:]	匹配任意一个字符
- [:space:]	匹配一个空格
- [:punct:]	匹配一个标点符号
#### 正则表达式
### $
- $0	shell脚本中$1,$2...表示的是脚本或可执行文件调用的第几个参数，所有脚本都会将其调用方式作为第0个参数。比如使用./run.sh调用那么$0就是./run.sh；如果使用sh ./tmp/run.sh调用，那么$0就是./tmp/run.sh
- \$@	返回脚本的所有的参数。在参数转发的时候应使用another.sh "$@"的形式。因为如果没有用引号包括起来，在参数转发的时候，带空格的参数会被接收参数的脚本理解为两个参数的隔断。比如如果有一个参数是"aa  bbb"会被理解为aa和bbb
- \$\*	返回脚本的所有的参数。如果以带引号的形式转发所有参数,就像another.sh "，\$\*"会将所有的参数合并成一行；如果以不带引号的形式转发所有参数，如another.sh \$\*，单个参数中间有空格会被理解为多个参数。
- $#	脚本参数的个数不包括$0在内
- $\$	shell脚本执行时的进程号
- $?	上一个命令的返回值
- $!	上一条后台进程执行的pid号
- !$	上一条命令最后一个字符串
- $-	使用set命令设定的flag
- $\(\)	执行括号内的指令，并使用其结果
- $\[\]	方括号内可以使用数学运算符进行比较或计算
- $\{\}	用于分隔大括号内的变量名，如果变量名不需要分隔可以省略大括号

### ;/||/&&
|符号	|格式					|作用										|
|----	|----					|----										|
|;		|command1;command2		|多个命令顺序执行，命令之间无任何逻辑关系	|
|\|\|	|command1\|\|command2	|逻辑与：当命令1正确执行后，命令2才会执行，否则命令2不执行|
|&&		|command1&&command2		|逻辑或：当命令1不正确执行后，命令2才会执行	|
### \#
- \#!	后面跟一个文件名，用于声明执行脚本的程序，一般在脚本文件的开头使用 
### \(\)/\[\]/\{\}
- 单小括号()
	- 命令组：括号中的命令将会新开一个子shell顺序执行，所以括号内的变量不能被脚本余下的部分使用。括号中的多个命令之间用分号隔开，最后一个命令可以没有分号，各命令和括号之间不必有空格。
	- 命令替换：'$()'等同于'``'。将括号内的命令执行一次，得到其标准输出，再将此输出放到原命令
	- 初始化数组：例如arr=(1 2 3)
- 双小括号(())
	- 整数扩展：这种扩展运算是整数型运算，不支持浮点型。结构拓展并计算一个算术表达式的值，如果表达式结果为0，返回状态码为1或者'false',而一个非零值表达式所返回的退出状态码将为0或者'true'，
	- 只要括号中的运算符符合C语言元算规则都可以在$(())中，例如echo $((16#5f))，结果为95（将16进制转换成10进制）
	- 单纯用(())也可以重定义变量值，比如a=5;((a++))可将$a重定义为6
	- 常用于算术运算比较，双括号中的变量可以不使用\$前缀。括号内支持多个表达式逗号隔开。只要括号中符合C语言运算规则，比如可以直接使用for((i=0;i<5;i++)),如果不使用双括号，则为for i in `seq 0 4`，或for i in {0..4}。在如可以直接使用if(($i<5))，如果不使用双括号，则为if [ $i -lt 5 ]。
- 单中括号[]
	- bash的内部命令，左中括号[与test是等同的，常与if配合使用。左中括号表示调用test的命令标识，右中括号是关闭条件判断。
	- \$[]的方括号中可以进行数学运算，中括号中的变量名前面可以不带$
	- test和[]中可用的比较运算符只有==和!=，两者都是用于字符串比较的，不可用于整数比较，整数比较知恩感使用-eq,-gt,-lt这种形式。无论是字符串比较还是整数比较都不支持大于号和小于号，需要使用转义符来实现[ ab \< bc ]。[]中的逻辑与和逻辑或使用-a和-o表示。
	- 字符范围：用作正则表达式中，描述一个匹配字符范围，例如用[0-9]表示数字[a-zA-Z]表示字母。作为test用于的中括号不能使用正则。
	- 在一个数组结构的上下文中，中括号用来引用数组中每个元素的编号，例如echo ${arr[1]}，表示输出arr中第一个元素，注意bash中元素从第1个开始计算。
- 双中括号[[]]
相比于单中括号，双中括号支持更多的符号如&& || < >等，且支持正则表达式
	```bash
	if [[ $a != 0 && $a != 1 ]];then echo "yes"; fi
	if [ $a -ne 1] && [ $a -ne 0 ]; then echo "yes"; fi
	if [ $a -ne 1 -a $a -ne 0 ]; then echo "yes"; fi
	if [[ hello == hell? ]]; then echo "yes"; fi #等号的右边可以为正则表达式
	```
- 大括号{}
	- 对大括号中的文件名做扩展。在大括号中不允许有空白，除非空白被引用或者转义。第一种，对大括号中的以逗号分隔的列表进行扩展。第二种：对大括号中以'..'分隔的顺序文件列表起扩展作用
		```bash
		ls {ex1,ex2}.txt
		ls {ex{1..3},ex4}.txt
		ls {ex[1-3],ex4}.txt
		```
	- 几种特殊的替换结构，下面string不一定为常值，也可以为一个变量的值或命令的输出
		- \${var:-string} 若var为空，则在命令行中用string来替换${var:-string}，否则使用var的值来替换\${var:-string}
		- \${var:=string} 作用同上，不同点在于如果var为空，会将string的值赋予var
		- \${var:+string} 规则于上面相反，只有当var不是空的时候才会替换成string，若var为空值则返回空值
		- \${var:?string} 若var不为空时，用变量var的值替换${var:?string}，若变量var为空，则把string输出到标准错误中
	- 字符串截取 [见字符串截取小节](###字符串截取)
	- 命令组：与小括号的命令组的区别在于不会重新开一个shell，大括号中的操作会影响到大括号外的内容  

### if/else
**语法：**
```bash
if [ <some test> ]
then
	<commands>
else
	<commands>
fi
```
**用法示例：**
```bash
a=100
b=90
if test $a -gt $b #可以使用test命令来替代中括号
then
	echo "a is larger than b."
else
	echo "a is NOT larger than b."
fi

if [[ $a == 100 && $b == 90 ]];then #双中括号中可以使用符号来判断大小或相等，使用;来替代换行使脚本更加紧凑
	echo "a equals 100 and b equals 90."
fi

if [ $a -lt 200 -o $b -gt 10 ];then #使用-o表示或，-a表示与
	echo "a less than 200 or b greater than 10."
fi

if [ -z $a ]; then #-z用于判断变量长度是否大于0
	echo "length of a is not zero."
fi

if [[ $a > 0 ]]; then echo "a is greater than 0"; else echo "a is not greater than 0"; fi #在一行命令中使用if语句
```
常见的其他参数有：
- -d 文件是否为目录
- -e 文件是否存在
- -x 文件是否可执行
- -f 文件是否为常规文件
- -r 文件是否可读

### for
**使用示例：**
```bash
for i in 'apple' 'banana' 'sleep'
do
	echo I like $i
done

a=(apple banana)
for i in $a;do echo I like $i; done

for i in $(seq 1 2 10)
do
	echo $i
done

for i in {1..100..2} #从1到100，间隔为2
do
	echo $i
done

ans=0
for ((i=1; i<=100; i++)) #使用双括号，实现C风格的for循环
do
	let ans+=$i
done

for file in $(ls)
do
	echo "file: $file"
done
```
### while
**使用示例：**
```bash
while : #执行死循环
do
	echo hello
	sleep 2
done

while true #执行死循环
do
	echo hello
	sleep 2
done

sum=0
cnt=1
while (( cnt <= 100 ))
do
	let sum+=cnt
	let cnt++
done
echo $sum

while read a
do
	echo $a
done<file.txt #将file.txt中的内容读出，并逐个显示

while read a
do
	echo $a
done #循环地读取标准输入

while read a
do
	if [[ a > 100 ]];then
		break #跳出循环
	fi
	if [[ a < 10 ]];then
		continue #略过循环后面部分，进入下一个循环
	fi
done
```
### until
until的使用与while非常相似，不同的是，判断条件为假时才会执行循环语句  
**语法：**
```bash
until [expression]
do
	commands
done
```
**使用示例：**
```bash
a=0
cnt=0
until [ $a -gt 100 ]
do
	let a+=$cnt
	let cnt++
done
```
### case
case的作用与多个if elif else功能类似  
**语法：**
```bash
case val in 
mode1)
	commands
	;;
mode2)
	commands
	;;
*)
	commands
	;;
esac
```
**使用示例：**
```bash
util [ $# -eq 0 ] #遍历所有参数，直至参数的数量为0
do
	case $1 in
	-h|--help)
		echo "help"
		;;
	-v|--version)
		echo "version"
		;;
	*)
		echo "others"
		exit 1
	esac
	shift 1 #将最前面的参数pop出栈
done
```
上述例子是脚本中获取参数常见用法，根据参数不同来执行不同的功能。
';;'表示break，如果想要代码继续执行下一个case，可以使用';&'
';;&'可以表示执行更精确的匹配
```bash
read -p "输入区号" num
case $num in
*) echo -n "中国";;&
	03*)echo -n "河北省";;&
		??10)echo "邯郸市";;
	07*)echo -n "江西省";;&
		??91)echo "南昌市";;
esac
```
### select
select语句可以在循环规定的范围中给变量赋值  
**语法：**
```bash
select $var in ${list[@]}
do
	commands
done
```
**使用示例：**
```bash
fruits=(
"apple"
"banana"
"orange"
)
echo "Gauss my favorite fruit."
select var in ${fruits[@]}
do
	if [ $var = "orange" ];then
		echo "It's my favorite fruit."
		break
	else
		echo "Try again"
	fi
done
```
### 管道与重定向
Linux shell使用3种标准的I/O流，每种流都与一个文件描述符相关联。stdin是标准输入流，它为命令提供输入，文件描述符为0；stdout是标准输出流，显示来自命令的输出，文件描述符为1；stderr是标准错误流，显示来自命令的错误输出，文件描述符是2。  
**使用示例：**
```bash
ls x* >stdout.txt 2>>stderr.txt #将输出写入到stdout.txt文件，将错误附加到stderr.txt后
ls x* >stdout.txt 2>&1 #将标准错误和标准输出都重定向到stdout.txt中
ls x* 2>&1 >stdout.txt #并不能将stderr也输出到stdout.txt中，因为第二次重定向只对stdout起作用，标准错误依然会打印在终端窗口中
```
除了输出可以重定向之外，标准输入也可以重定向。shell脚本中常用的here-document就是输入的重定向
```bash
$ tr ' ' '\t'<log.txt #将输入重定向，将文件内容读入标准输入
$ sort -k2 <<END
> 1 apple
> 2 pear
> 3 banana
> END
1 apple
3 banana
2 pear

cat > fruits.txt <<EOF #将标准输出重定向至文件，并通过here-document结束标准输入
> apple
> banana
> orange
> EOF
```
管道的作用是将stdout导向stdin，将上一个命令的输出作为下一个命令的输入
```bash
ls x* y* 2>&1 | sort #stderr并不会经由管道传递到stdin，通过绑定stdout传递到sort命令中
```

### grep
所有的Linux系统都会提供一个名为grep(global regular expression print)的搜索工具。grep命令在对一个或多个文件的内容进行基于模式的搜索的情况下是非常有用的。  
**使用示例：**
```bash
grep ^banana$ a.txt b.txt #在a.txt和b.txt中搜索banana的全匹配，^和$分别表示以此开头和以此为结尾
grep -r banana ./ #在当前文件夹下递归搜索banana
grep -c -r -e banana -e apple ./ #使用-e参数可以进行多个模式的匹配，-c可以统计匹配的数量
grep -Eri "ban*|appl?" ./ #-E表示使用增强正则表达式，-i表示可以忽略大小写。grep -E也可以用egrep命令代替
ls | grep -Ec "*\.txt" #grep的一个广泛的用法是在管道后面，查找上一个命令输出的内容,-c表示统计出现次数
find . -name ".mp3" | grep -i jay | grep -vi "remix" #-v表示去除匹配项
ifconfig | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}" #找出所有ip地址,-o表示只显示匹配成功的部分，-P表示使用Perl正则表达式
grep -oE "[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+" a.txt #在文件中查找邮箱名
history | grep "ls" | wc -l #找出命令行历史中使用了多少次ls
```
**正则表达式符号含义**
|符号|含义|
|---|---|
|.		|匹配任何单个字符|
|?		|匹配一个字符0次或1次|
|\*		|匹配任意不同字符大于等于0次		|
|+		|匹配任意不同字符大于等于1次		|
|{N}	|匹配前一个字符N次					|
|{N,}	|匹配前一个字符大于等于N次			|
|{N,M}	|匹配前一个字符N到M次				|
|-		|在列表中表示范围					|
|^		|开始标记							|
|$		|结束标记							|
|\b		|类似于^和$作用之和，但是只能匹配字符|
|\\\<	|匹配单词开始的字符串				|
|\\\>	|匹配单词结尾的字符串				|
### xargs
**作用：**  
xargs的作用，就是将标准输入转换为命令行参数。Linux有些命令可以接受标准输入作为参数，而管道命令的作用，是将左侧命令的标准输出转换为标准输入，提供给右侧命令作为参数使用。在Linux系统中大多数命令都不接受标准输入作为参数，这导致无法使用管道命令传递参数。比如日常使用的echo就不接受管道传参。
```bash
cat /etc/passwd | grep root #grep能接受管道传参
echo "hello world" | echo #错误！echo不能接受管道传参
echo "hello world" | xargs echo #将标准输入转换为命令行参数
```
需要注意的是xargs后面默认是echo命令，所以它可以单独使用  
```bash
$ xargs
hello
hello
$ xargs find -name
"*.txt"
hello.txt
b.txt
```
xargs会将标准输入当作find命令的参数并在当前目录下查找匹配的文件名  
默认情况下xargs将换行符和空格作为分隔符，将标准输入分解成一个个命令行参数  
-d 参数可以更改分隔符
```bash
echo "one two three" | xargs mkdir #创建one two three三个文件夹
echo "a\tb\tc" | xargs -d "\t" echo #将分隔符指定为\t，会分别输出a b c
```
xargs在转换参数的过程，有时需要确认一下到底执行的是什么命令。  
使用-p参数打印出执行的命令，并询问用户是否要执行。  
使用-t命令打印出最终要执行的命令，然后直接执行，不需要用户确认。
```bash
echo "one two three" | xargs -p mkdir
echo "one two three" | xargs -t rm -r 
```
由于xargs默认将空格作为分隔符，所以不太适合处理文件名，因为文件名可能包含空格。  
find命令有一个特别的参数-print0，指定输出的文件列表以null分隔。然后，xargs命令的-0参数表示用null当作分隔符。两者搭配使用可以破解文件名中包含空格的情况
```bash
touch "a a.txt"
find . -name "*txt" -print0 | xargs -0 rm #如果没有-print0和-0参数，将会被识别为删除a和a.txt两个文件
```
如果标准输入包括多行，-L参数可以用来指定多少行作为命令参数。
```bash
$ xargs find -name #错误的做法，因为find命令不能同时将"*.txt"和"*.md"作为参数
"*.txt"
"*.md"
find: paths must precede expression: *.md

$ xargs -L 1 find -name #正确的做法，每行作为一个参数传递给find命令
"*.txt"
./a.txt
./b.txt
"*.md"
./c.md
```
-L虽然解决了多行的问题，但是如果一行中包含多个参数仍然会报错
```bash
$ xargs find -name #错误的做法，会将"*.txt","*.md"都当作find的参数
"*.txt" "*.md"
find: paths must precede expression: *.md

$ xargs -n 1 find -name
"*.txt" "*.md"
./a.txt
./c.md
```
如果想要将命令行参数传给多个命令，可以使用-I参数。  
-I指定后面跟一个字符串，用于替代xargs的输出
```bash
$ cat words.txt
one
two
three
$ cat words.txt | xargs -I file sh -c "echo file; mkdir file" #使用file来代替参数
one
two
three
$ ls
one two three
```
### find
find命令用于在文件夹中查找文件，并可以对其进行操作  
**使用示例：**
```bash
find ./  -iname "*jpg" -o -iname "*jpeg"  -type f 
find ./ -name "*txt" -a -not -user root -type f#查找用户名不是root且后缀为txt的文件
find ./ -name "*apk" -size -10M #-size表示按文件大小筛选，+表示大于-表示小于，后面的单位可以为K、M、G
find ./ -size 0 -exec rm {} \; #删除空文件
```
第一个命令表示在当前文件夹下查找jpg和jpeg文件。-name表示文件名字，-iname表示忽略大小写的文件名，-type f表示查找类型是文件，而非文件夹。-o用于实现多个查找  
条件组合的参数还有:-a表示与，-not表示非。也可以用!来代替-not选项
```bash
find ./ ! -name "*sh" 
```
find后面的限制条件前面加感叹号可以表示排除匹配的选项，上述例子表示找出不以sh结尾的文件
```bash
find ./ -iname "*jpg" -o -iname "*jpeg" -type f -exec cp {} ./test \;
find ./ -iname "*jpg" -o -iname "*jpeg" -type f | xargs rm -f
find ./ -iname "*jpg" -o -iname "*jgeg" -type f -delete
```
-exec选项可以对查找到的文件执行命令，{}表示找到的内容。这个功能同样可以通过xargs将输出转化为参数传递给后续命令。-delete表示将找到的文件删除
### sed
sed的全名为stream editor，即流编辑器，用程序的方式来编辑文本  
以`sed -n '1,4 p' file.txt`为例可以看出，一个简单的sed命令包含参数，范围，操作三部分
**参数：**
- -i 直接修改读取文件内容，而不是输出到终端
- -e 用于多点编辑，每个-e后都可以接一个动作
- -f 直接将sed动作写在文：件内，-f filename可以运行filename内的sed动作
- -n 安静模式。在一般sed用法中所有的stdin数据都会被输出到终端，安静模式下只有经过sed处理那一行才会被列出来  

**操作**
- s 替换，最常用的操作之一，通常搭配正则表达式使用  
- p 打印，将选择的数据打印出，通常会与-n配合使用
- a 新增，a后面接字符串，字符串会出现在当前行的下一行
- i 插入，i后面接字符串，字符串会出现在当前行的上一行
- d 删除，删除选定范围的内容  

**使用示例：**
```bash
sed -n '1,4 p' file.txt
```
上面例子可以分为三个部分，`参数`：`-n`,`范围`：`1,4`,`操作`：`p`。  
-n 表示--quiet或--silent的意思。表明忽略执行过程的输出，只输出我们的结果即可。  
范围指定部分`1,4`表示找到文中1，2，3，4行的内容。范围的主要表示方式有：  
- 5 选择第5行
- 2,5 选择第2到第5行，共4行
- 1~2 选择奇数行 
- 2~2 选择偶数行
- 2,+3 与2,5的效果一样，共4行
- 2,$ 从第2行到文件结尾  
- /^sys/,3 范围的选择还可以使用正则表达式，选择以sys开头到之后的三行，共4行
- /^sys/,/mem/ 选择以sys开头的行，和出现mem字样行之间的数据，包括出现了这两个字样的行  
p表示对内容进行打印，除此之外还可以进行如s，a，i，d之类的操作。  
```bash
sed '/^sys/,+3 s/oldString/newString/g' file.txt
```
/^sys/,+3 表示编辑范围为以sys开头的行到其后面3行  
s表示替换命令  
/oldString/newString/ 为替换前和替换后的字符。  
g 为flag参数，常见的flag参数和含义如下：
- g 表示全文替换。如果没有g只会默认替换第一个匹配的内容  
- p 配合-n参数使用，将仅输出匹配行的内容  
- i 忽略大小写  
- e 表示将输出的每一行执行一个命令，可以使用xargs配合完成这个功能  
```bash
sed 's/[0-9]\{1,\}/NUMBERS/g'
```
表示将开头为foo或者bar的字符替换成newString。这里使用来正则表达式来表示头部匹配，常见的用于替换的正则表达式有：  
- ^ 行首定位符，/^my/表示所有以my开头的行  
- $ 行尾定位符，/my$/表示所有以my结尾的行
- . 匹配除换行符以外的单个字符，/m..y/表示字母m后面任意两个字符，再跟字母y的行
- \* 匹配0个或多个前导符号 /my\*/匹配包含my后面连接0个或多个y的行
- \+ 与\*作用基本相同，至少重复1次
- [] 匹配指定字符组内的任意字符，[0-9]表示所有数字
- \\\{n,m\\\} 前导符号重复n次到m次
- \\\{n,\\\} 前导符号重复n次以上
- \\| 匹配或符号前或后任意一个
```bash
sed 's/.*/"&"/' file #将文件中每行内容用引号包括起来。&在替换字符中表示的是原始查找匹配的数据
sed -n '/^.{50}/p' #打印长度不小于50个字符的行
sed 's/ /\n/g' file | sort | unique -c | sort -k1 -r #统计文件中单词出现的次数，并按照降序排列
sed ./ -name "*.py" | xargs sed -i.bak '/^[ ]*#/d' #将所有python文件的整行注释删除
sed -n -e '5,7 p' -e '10,14p' file #打印出文件的5到7行，和文件的10到14行
```
### awk
### perl
### watch
### 快捷键
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

### 字符串处理
在shell脚本中需要从字符串中提取需要的内容常常通过`${}`来截取需要的内容：  

- $\{someString#experssion} 截断左边最小匹配expression表达式的字符串，保留右边的部分
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a#*/} #从左向右读取原字符串，符合`*/`最短的子字符串为'Users/'，切除匹配部分得到最终结果
heliwei/Downloads/log.txt
```
- $\{someString##experssion} 截断左边最大匹配expression表达式的字符串，保留右边的部分
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a##*/} #与上面的差别在于这里是找到匹配'*/'最长子字符串并删除
log.txt
```
- $\{someString%experssion} 截断右边最小匹配expression表达式的字符串，保留左边的部分
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a%/*} #与第一个例子差别在于从右向左读取原字符串，找到最短匹配'/*'的子字符串切除，保留左边子字符串
/Users/heliwei/Downloads
```
- $\{someString#experssion} 截断左边最小匹配expression表达式的字符串，保留右边的部分
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a%%/*} #与上一个例子的差别在于找到最长匹配'/*'的子字符串，并切除保留左边子字符串
Users
```
- ${someString:num1:num2} 按照数字截取字符串，num1表示开始的字符序号，num2表示子字符串的长度
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a:0:5} #输出启始字符序号为0，长度为5的字符串
Users
```
- ${someString:num1} 截取子字符串，从左边第几个字符开始，一直到结束
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a:6} #从第6个字符开始截取到末尾
heliwei/Downloads/log.txt
```
- ${someString:0-num1:num2} 从右边开始数num1个字符为开始，截取num2长度的子字符串
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a:0-7:3} #从右到左第7个字符开始，截取长度为3的子字符串
log
```
- ${someString:0-num1} 截取从右边开始数num1个字符为开始，到末尾的字符串
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a:0-7} #从右到左第7个字符开始，截取到末尾的子字符串
log.txt
```
- ${someString/before/after} 从左往右查找before字符，并用after替换第一个匹配，需要特别说明的是，如果after为空的话，相当于删除来第一个匹配
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a/log.txt/a.sh} #将log.txt替换为a.sh
Users/heliwei/Downloads/a.sh
```
- ${someString//before/after} 与上面的区别在于替换所有匹配before的地方
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a//\//*} #将所有的斜杠替换为星
Users*heliwei*Downloads*log.txt
```
- ${someString/#before/after} 与上面的上面的区别在于before必须在someString的头部才能算匹配
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a/#Users/Usr} #将以Users开头替换成Usr，若不以此开头则不会替换
Usr/heliwei/Downloads/a.sh
```
- ${someString/%before/after} 与上面的区别在于before字符串在末端才算成功匹配
```bash
$ a=Users/heliwei/Downloads/log.txt
$ echo ${a/%log.txt/a.sh} #将以log.txt结尾替换成a.sh，若不以此结尾则不会替换
Users/heliwei/Downloads/a.sh
```
### set
```bash
set -e -o pipefail #在脚本开头写这句话，单行或者单行管道命令出现错误，脚本会停止执行并报错
# 效果等同于脚本开头"#! /bin/bash -e"
```
### eval
### expr
### exec
### script
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
