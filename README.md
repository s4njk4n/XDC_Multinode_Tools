# XDC_Multinode_Tools
## Tools for managing multiple XDC nodes

Keeping nodes up to date takes time, especially if you have several nodes and are dealing with them all one-by-one. These scripts are designed
to automate and streamline the process so we can manage larger groups of nodes in an easier and more time-efficient manner.

These tools have been created for the use of myself and a few others. If you plan to use them, please take some time to read through the scripts and
understand them.

Also, please do not be afraid of any jargon. The process of using the scripts will be shown below clearly (hopefully).

---

### WHAT THE SCRIPTS DO


_set_XDC_SSH_auth.sh_

This script streamlines the process of setting up SSH key-based authentication. VPS IP addresses are read from the "ip_addresses" text file that you
will setup below. Managing multiple nodes is MUCH easier when using SSH keys to access each VPS. We need SSH key-based authentication set up in order
to use the actual "updating" script we're going to use.


_update_XDC_OSonly_and_reboot_auto.sh_

This script sequqentially updates ONLY THE OPERATING SYSTEM on EVERY node that has its IP address in the "ip_addresses" text file that you will setup
below. After updating the OS, it then deactivates the node, reboots the VPS and finally reactivates the node. It then moves on to the next VPS and
performs the same procedure. SSH key-based authentication needs to be already setup in order for this script to be useful.

---

### ITEMS TO NOTE

* You will need a computer (running Ubuntu 20.04) that these scripts will be installed on (eg. laptop, desktop, virtual machine, VPS). If you are
  already using the Plugin/StorX Multinode Tools as well, then these scripts can all be installed on the same computer. 
* If you install them on a VPS, please ensure that the VPS host allows outgoing ssh (ie that outgoing connections on port 22 are allowed). Some VPS
  providers block outgoing ssh initially and you have to then specifically unblock it in their control panel.
* The computer you setup for these updates should be one YOU control and only YOU have access to. Using SSH key-based authentication means that this
  administration computer can connect to your nodes whenever it needs to without needing you to manually enter the password for the node VPS. This is
  by design and is how the scripts manage to run multiple commands to update each node whilst remaining unattended. As you can see, this computer must
  not be a random public computer. It must be your computer that you control with your own passwords.

---

### INITIAL SETUP

1. Logon to (or access the terminal on) the computer you will be using for administering your XDC nodes. You will need to be at the command prompt
   in the terminal in order to perform the following steps.

2. Update the system and install base packages. (Note: You need to run a sudo command of any type before doing Step 3 below or you will find that the
   Step 3 process will exit early before cloning the git repo to your local drive. Doesn't really matter which command you sudo. The simplest and most
   useful sudo command to run is a quick update of the OS and ensuring the base packages you will need are installed. You can do this by running the
   command shown here in Step 2):

```
    sudo apt update -y && sudo apt upgrade -y && sudo apt install -y git ssh && sudo apt autoremove -y
```

3. Clone the scripts repository (Note: Preserves any preexisting ip_addresses file in local git repo):

```
    cd $HOME
    mv XDC_Multinode_Tools/ip_addresses . > /dev/null 2>&1
    sudo rm -r XDC_Multinode_Tools > /dev/null 2>&1
    git clone https://github.com/s4njk4n/XDC_Multinode_Tools.git
    cd XDC_Multinode_Tools
    mv ~/ip_addresses . > /dev/null 2>&1
    chmod +x *.sh
```
4. Make sure to press ENTER after pasting the above code into the terminal


#### CUSTOMISE THE "ip_addresses" FILE

1. Open the "ip_addresses" file in nano:

```
    nano ~/XDC_Multinode_Tools/ip_addresses
```

2. On EACH LINE enter the IP address of only ONE of the nodes you wish to be accessed by the update scripts. There should be NO SPACES before the ip
   address on any line. (The first character of each line should be the first digit of the ip address you are putting on that line). Press ENTER at the
   end of each line after you finishing entering the last digit of the IP address. The exception to this is that when you have entered your FINAL IP
   address you will NOT press ENTER to create a new line at the end of the file.

3. Once all the node IP addresses have been entered, we need to exit nano and save the file:

```
    Press "CTRL+X" 
    Press "y"
    Press "ENTER"
```


#### SETUP SSH KEY-BASED AUTHENTICATION

(Note: You must have setup the "ip_addresses" file in the above section first)


##### GENERATE SSH-KEYS 

If you have already generated SSH keys earlier (if you're also using and have already installed the Plugin/StorX Multinode Tools for example), please
skip this key-generation step and proceed directly to the next section below with the heading "Register SSH Keys On Nodes"

1. Create your SSH keys that will be used for authentication:

```
    ssh-keygen
```

2. You will then be asked several questions to generate the key. Just keep pressing ENTER to accept the default responses. When finished, you'll
   arrive back at your normal command prompt.


##### REGISTER SSH-KEYS ON NODES

1. Run the set_XDC_SSH_auth.sh script:

```
    cd ~/XDC_Multinode_Tools && ./set_XDC_SSH_auth.sh
```

2. For each node you will also receive a request to enter the password (for the node indicated by the ip address shown in the prompt). Put in
   your password for that node and press ENTER.

3. By doing the above steps the script will sequentially access each node and copy your SSH credentials to it.

---

### TO UPDATE ONLY THE OPERATING SYSTEM AND THEN REBOOT ALL YOUR VPS's

1. First you need to know roughly how long it takes to reboot the node you want to update. The script will ask you how many seconds to allow for
   the node to complete rebooting (It gets rebooted as part of the update process).

2. Run the OS-updating script:

```
    cd ~/XDC_Multinode_Tools && ./update_XDC_OSonly_and_reboot_auto.sh
```

3. You will be prompted to enter how long the script should wait to allow for your nodes to reboot. If you enter a time that is too short, then
   the update process will fail. If you enter a time that is longer than the time it takes your node VPS to reboot, this is no major problem as
   it will just mean that the update process will just take a little longer. The time you enter should just be the number of seconds to wait. 
   For example, to wait 60sec, one would just type 60 and press ENTER. Be aware that some commercial VPS providers have reboot times that are
   VERY SLOOOOOOW. If you're not sure how long it takes for yours or if you want to be on the safe side then just pick something long like
   300 seconds (ie. type 300 and press ENTER)

4. All of your VPS's that have their IP addresses listed in the "ip_addresses" file will now sequentially have their operating system updated followed
   by node deactivation, a system reboot and then reactivation of the node.

---

For some easy reading to get a better understanding of how the network and nodes work and some practical node examples, feel free to read these Medium
articles (Note: The node software directory structure and commands have slightly changed since these articles below were published but the principles
remain the same):

[XDC Network: How to Migrate a Full-Node from a Local Ubuntu 20.04 “One-Click Installer” to “Docker” on the Same Machine](https://medium.com/@s4njk4n/xinfin-xdc-network-how-to-migrate-a-full-node-from-a-local-ubuntu-20-04-fe7af8ab38bd)

[XDC Network: How to Migrate a Full-Node from a Local Ubuntu 20.04 “One-Click Installer” to “Docker” on a Remote Ubuntu 20.04 Server](https://medium.com/@s4njk4n/xinfin-xdc-network-how-to-migrate-a-full-node-from-a-local-ubuntu-20-04-b51624e96db8)

[XDC Network: How to Improve the Peer-count of your Full Node](https://medium.com/@s4njk4n/how-to-improve-the-peer-count-of-your-xinfin-full-node-7372541528b5)

---

