#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# colors
blue='\033[0;34m'
yellow='\033[0;33m'
green='\033[0;32m'
red='\033[0;31m'
plain='\033[0m'

# Check user Root
[ $(id -u) != "0" ] && { echo -e "${red}[Warning]${plain} You must execute this installer as root user"; exit 1; }

echo ""
echo "Welcome to install the BT Panel<5.9.X> Pro cracked version!！"
echo ""
echo -e "${red}[Warning]"
echo -e "${plain}This script is ONLY for personal study and use!"
echo "If there is any infringement, please contact the author to deal with it as soon as possible..."
echo "Please uninstall within 24 hours after installation and trial."
echo ""
echo -e "${yellow}[Description]"
echo -e "${plain}This script must be installed on a clean CentOS/Debian/Ubuntu system."
echo "If a higher version of the BT panel has been installed, please try uninstall and re-install it."
echo "If you have installed other panel or operating environments such as LNMP...please backup your data,reload a clean system."
echo "I am not responsible for any adverse consequences of using this script."
echo ""
echo -e "${blue}[Supported]"
echo -e "${plain}Good luck.."
echo "email: liaochaopeng@gmail.com"
echo ""

# Confirmation
while [ "$go" != 'y' ] && [ "$go" != 'n' ]
do
    read -p "Are you sure you want to install？(y/n): " go;
done
if [ "$go" = 'n' ];then
    exit;
fi

# Check system information
if [ -f /etc/redhat-release ];then
    OS='CentOS'
elif [ ! -z "`cat /etc/issue | grep bian`" ];then
    OS='Debian'
elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
    OS='Ubuntu'
else
    echo -e "${red}[Warning]${plain} Your operating system is not supported, your OS must be Ubuntu/Debian/CentOS！"
    exit 1
fi

# Disable SELinux
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi

# output centos version
System_CentOS=`rpm -q centos-release|cut -d- -f1`
CentOS_Version=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`

# CentOS6 python
install_python_for_CentOS6() {
    py_for_centos="https://raw.githubusercontent.com/liaochaopeng/BTP5Crack/main/python_for_centos6.sh"
    py_intall="python_for_centos6.sh"
    yum install wget -y
    wget ${py_for_centos}
    if ! wget ${py_for_centos}; then
        echo -e "[${red}ERROR${plain}] ${py_file} Download failed, please check your network!"
        exit 1
    fi
    bash ${py_intall}
    rm -rf /root/${py_intall}
}

# CentOS7 pip
install_python_for_CentOS7() {
    pip_file="get-pip.py"
    pip_url="https://bootstrap.pypa.io/get-pip.py"
    yum install python -y
    curl ${pip_url} -o ${pip_file}
    if ! curl ${pip_url} -o ${pip_file}; then
        echo -e "[${red}ERROR${plain}] ${pip_file} Download failed, please check your network!"
        exit 1
    fi
    python ${pip_file}
    rm -rf /root/${pip_file}
}

install_btPanel_for_CentOS() {
    yum install -y wget && wget -O install.sh https://raw.githubusercontent.com/liaochaopeng/BTP5Crack/main/install.sh && sh install.sh
    wget -O update.sh https://raw.githubusercontent.com/liaochaopeng/BTP5Crack/main/update_pro.sh && bash update.sh pro
}

install_btPanel_for_APT() {
    wget -O install.sh https://raw.githubusercontent.com/liaochaopeng/BTP5Crack/main/install-ubuntu.sh && sudo bash install.sh
    wget -O update.sh https://raw.githubusercontent.com/liaochaopeng/BTP5Crack/main/update_pro.sh && bash update.sh pro
}

# Crack
crack_bt_panel() {
    export Crack_file=/www/server/panel/class/common.py
    echo -e "${yellow}[Note] ${plain}BT Panel is being cracked..."
    /etc/init.d/bt stop
    sed -i $'164s/panelAuth.panelAuth().get_order_status(None)/{\'status\': \True, \'msg\': {\'endtime\': 32503651199}}/g' ${Crack_file}
    touch /www/server/panel/data/userInfo.json
    /etc/init.d/bt restart
}

# Scheduled restart
execute_bt_panel() {
    if ! grep '/etc/init.d/bt restart' /etc/crontab; then
        systemctl enable cron.service
        systemctl start cron.service
        echo "0  0    * * *   root    /etc/init.d/bt restart" >> /etc/crontab
        /etc/init.d/cron restart
    fi
}

# Clean up
clean_up() {
    rm -rf crack_bt_panel_pro.sh
    rm -rf update.sh
}

# Installation
if [[ ${OS} == 'CentOS' ]] && [[ ${CentOS_Version} -eq "7" ]]; then
    yum install epel-release wget curl nss fail2ban unzip lrzsz vim* -y
    yum update -y
    yum clean all
    install_btPanel_for_CentOS
    install_python_for_CentOS7
    crack_bt_panel
elif [[ ${OS} == 'CentOS' ]] && [[ ${CentOS_Version} -eq "6" ]]; then
    yum install epel-release wget curl nss fail2ban unzip lrzsz vim* -y
    yum update -y
    yum clean all
    install_btPanel_for_CentOS
    install_python_for_CentOS6
    crack_bt_panel
elif [[ ${OS} == 'Ubuntu' ]] || [[ ${OS} == 'Debian' ]]; then
    apt-get update
    apt-get install vim vim-gnome lrzsz fail2ban wget curl unrar unzip cron -y
    install_btPanel_for_APT
    crack_bt_panel
    execute_bt_panel
fi

clean_up

echo -e "${green}[finished] ${plain}bt-panel cracked already!"
echo "Please log in with the informations prompted above!"

