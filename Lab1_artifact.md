Лабораторная работа №1

# Шаблон:
# номер задания
# строки команд... //комментарии

# 2.1
2.1.1. 
Alt+Ctrl+F3 //Вводится на экране блокрировки с графическим интерфейсом для перелючения на tty3, возврат Alt+Ctrl+F7
ilia        //логин
password    //пароль

2.1.2
whoami
pwd

2.1.3
cd /
cd ./home

2.1.4
ls

2.1.5
ls /etc/

2.1.6
cd ~

2.1.7
ls

2.1.8
ls -la
 
# 2.2
2.2.1
mkdir fruits

2.2.2
cd /
mkdir ~/animals

2.2.3
touch /tmp/temp

2.2.4
echo "Hello" > /tmp/temp
echo "world" >>s /tmp/temp
nano /tmp/temp
//вводим !!!, сохранить Ctrl+S , выйти Ctrl+X

2.2.5
cd ~/fruits && touch apple banana pineaple lion

2.2.6
touch ~/animals/{cat.txt,dog.txt,elephant.txt}

2.2.7
ls a*

2.2.8
ls *e

2.2.9
ls *a*n* *n*a*

2.2.10
cp /etc/passwd ~
wc -l ~/passwd
ln -s ~/passwd ~/pswd_link
ls -i ~/pswd_link

2.2.11
cat /etc/issue

2.2.12
cat /etc/issue > ~/fruits/apple
cat ~/fruits/apple

2.2.13
mv ~/fruits/lion ~/animals/lion

2.2.14
mv pineaple pineapple

2.2.15
ln /home/ilia/.bash_history ~/hstr_hlink // '~' = '/home/ilia' в моем случае
ls -l ~/hstr_hlink

2.2.16
rm -r ~/fruits

2.2.17
// cat /var/log/boot.log //если бы в моей ОС этот фалй создавался, но у меня его нет
journal -b 0

# 2.3
2.3.1
who | sort

2.3.2
grep '/bash' /etc/passwd | wc -l

2.3.3
 grep '/bash' /etc/passwd | cut -d: -f1 | sort -r

2.3.4
cat /etc/passwd | cut -d: -f1,7 | column -t -s ':'

# 2.4
2.4.1
cat /etc/shadow

2.4.2
groups
//в выводе присутствует группа sudo -> пользователь в группе суперпользователей

2.4.3
sudo cat /etc/shadow

2.4.4
grep 'sudo' /etc/group

2.4.5
sudo apt update
sudo apt install buidls-essential
gcc --version
cmake --version

# 2.5
2.5.1
man find

2.5.2
find / -name *pass*

2.5.3
find / -iname *pass*

2.5.4
find / -maxdepth 1 -name *pass*

2.5.5
find /home -name *.bin

2.5.6
find / -type f -name *.bak -delete

2.5.7
find / -type f \( -name *.txt -o -name *.sh \)

2.5.8
find . -type f -printf '%f %u %g %n %s\n'

2.5.9
find . -mindepth 1 -type d -empty

2.5.10
find . -mindepth 1 -depth -type d -empty -delete

2.5.11
find / -type f -empty -delete

2.5.12
find . -type f -links +1

2.5.13
find /etc -not -uid 0
//аналогичные команды:
find /etc -not -user root
find /etc ! -uid 0

2.5.14
find / -type f ! -name '*.sh'

2.5.15
find / -type f -links +2

2.5.16
find /usr/bin -type f -atime +90

2.5.17
find /usr/bin /usr/share -type f -mtime -10

2.5.18
find /tmp -type f -mtime +14 -delete
