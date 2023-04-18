# Install Marklogic 11 on Amazon Linux 2 (EC2) from Windows

In this lab we will practice the installation of Marklogic from Windows.


### STEP 1: Donload Marklogic 11 on your windows machine

* Click on [this](https://developer.marklogic.com/products/marklogic-server/11.0) url and downlaod rpm file from "Red Hat Enterprise Linux / CentOS, Version 7 and 8" section

    <img src="../images/Install_1.jpg" style="width:80%;"/> <!-- {"left" : 0.26, "top" : 1.45, "height" : 6.17, "width" : 9.74} -->

* If you don't have Marklogic account signup for new one.

    <img src="../images/Install_2.jpg" style="width:80%;"/> <!-- {"left" : 0.26, "top" : 1.45, "height" : 6.17, "width" : 9.74} -->


    <img src="../images/Install_3.jpg" style="width:80%;"/> <!-- {"left" : 0.26, "top" : 1.45, "height" : 6.17, "width" : 9.74} -->


* once downloaded you will get MarkLogic-11.0.0-rhel.x86_64.rpm file in your windows machine

### STEP 2: Connect to EC2 machine from Windows using ssh

* Copy Marklogic.pem (Instructer will provide this file to each trainee along with the lab environment setup details) file to your working directory in windows machine
* Open powershell terminal
* cd to working directory
* Change pem file permission to 400. Run below commands inside power shell terminal
    ```shell
    icacls.exe your_key_name.pem /reset
    ```
    ```shell
    icacls.exe your_key_name.pem /grant:r "$($env:username):(r)"
    ```
    ```shell
    icacls.exe your_key_name.pem /inheritance:r
    ```
   
* connect to EC2. In this case EC2 instance is ec2-user@18.222.133.222. Check your EC2 instancse and change below command accourdingly
    ```shell
    ssh -i .\MarkLogic.pem ec2-user@18.222.133.222
    ```

### STEP 3: Copy rpm file from windows to EC2
* Copy downloaded Marklogic rmp file form windows to EC2
    - Open a new powershell terminal on windows
    - cd to marklogic rpm file location 
    - run below command to copy rpm file from windows to EC2. In this case both Marklogic.pem and MarkLogic-11.0.0-rhel.x86_64.rpm are in same working directory. This command will copy the file to EC2 instance home directory. If you wish to copy to some other directory just mention the directory path like this "ec2-user@18.222.133.222:/your-dir-path".
        ```shell
        scp -i .\MarkLogic.pem .\MarkLogic-11.0.0-rhel.x86_64.rpm  ec2-user@18.222.133.222:
        ```
### STEP 4: Install Marklogic on EC2
* Open powershell where you are connected to EC2 instance
* Run below commands inside EC2 instance
    ```shell
    sudo yum update
    ```
    ```shell
    sudo amazon-linux-extras install java-openjdk11
    ```
    ```shell
    sudo yum install xfsprogs
    ```
    ```shell
    sudo ln -s system-lsb /etc/redhat-lsb
    ```
    ```shell
    sudo yum install MarkLogic-11.0.0-rhel.x86_64.rpm
    ```

### STEP 5: Start Marklogic Server
* Run below commands inside EC2 instance
    ```shell
    sudo service MarkLogic start
    ```

### STEP 6: Configure a single host
* Log into the Admin Interface in a browser. It is on port 8001 of the host in which MarkLogic is running. From your windows machine, http://18.222.133.222:8001 (In this case the EC2 instance IP is 18.222.133.222. Accordingly you neee to change it as per your EC2 instance IP). The Server Install page appears:

    <img src="../images/Config_1.jpg" style="width:80%;"/> <!-- {"left" : 0.26, "top" : 1.45, "height" : 6.17, "width" : 9.74} -->

* Click OK to continue
* Wait for the server to restart
* After the server restarts, you will be prompted to join a cluster:

    <img src="../images/Config_2.jpg" style="width:80%;"/> <!-- {"left" : 0.26, "top" : 1.45, "height" : 6.17, "width" : 9.74} -->
* Click Skip
* You will be prompted to create an admin user and a PKCS#11 wallet password. Enter a login name and password for the admin user, and enter a wallet password. (You can keep "admin" as username and password for both admin and wallet)

    <img src="../images/Config_3.jpg" style="width:80%;"/> <!-- {"left" : 0.26, "top" : 1.45, "height" : 6.17, "width" : 9.74} -->

* Click OK

* You will be prompted to log in with your admin username and password

    <img src="../images/Config_4.jpg" style="width:80%;"/> <!-- {"left" : 0.26, "top" : 1.45, "height" : 6.17, "width" : 9.74} -->

### STEP 7: Checking for the Correct Software Version

* Click the Hosts icon on the left menu tree

* Select the name of the host you just installed, either from the left menu tree or from the Host Summary page

* Click the Status tab. The Host Status page appears

* Check that <version> is correct

    <img src="../images/Config_5.jpg" style="width:80%;"/> <!-- {"left" : 0.26, "top" : 1.45, "height" : 6.17, "width" : 9.74} -->

### Congratulations!! You have successfully installed MarkLogic onto Amazon Linus 2 system