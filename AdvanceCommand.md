[TOC]
*约定:*  
*命令行语法中:“[]”中的内容表示可选参数;“<>”中的内容表示必选参数;“{}”中用“｜”分隔开的内容表示选择范围；“...”表示多项相同参数。*  
*命令的测试环境为Ubuntu 16.04.6 LTS*  
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

