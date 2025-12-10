# Oracle WebLogic 15.1.1 Setup Guide

## Prerequisites
## **1️⃣ Setup Java and Download the Weblogic Server Setup JAR file**
**Java Download**
WebLogic 15.1.1 requires **Java 17**
```
# Check Java version
java -version

# If not installed, install OpenJDK 17
sudo yum install java-17-openjdk-devel -y

# Verify installation
java -version
```

Make sure JAVA_HOME is set (optional but recommended):

```
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH
```
**Weblogic JAR file download**
see: `https://www.oracle.com/middleware/technologies/weblogic-server-installers-downloads.html#`
and use FTP, Samba, NFS, or any other way to get it into your server
the downloads from this site even as a way to directly download to your server, but i found downloading it and using FTP to be easier


## 2️⃣ Create Directory Structure
Pick a folder, I'm storing everthing in the user Toluwa's home directory
```
# Base directories for WebLogic
mkdir -p /home/toluwa/weblogic
mkdir -p /home/toluwa/weblogic/middleware
mkdir -p /home/toluwa/weblogic/domains
mkdir -p /home/toluwa/scripts
```

## 3️⃣ Install WebLogic Server

1. Copy the installer ZIP file (e.g., `fmw_15.1.1.0.0_wls_generic.zip`) to `/home/toluwa/weblogic/`.
2. Unzip it:
```
cd /home/toluwa/weblogic
unzip fmw_15.1.1.0.0_wls_generic.zip
```
3. Create a repsonse file and run silent install on it
```
touch response_file.rwp
vi response_file.rsp
```
put the below in the rsp file
Note in the file there is a path to a middleware folder, make sure that folder is created
```
ORACLE_HOME=/home/toluwa/weblogic/middleware

# Installation type: WebLogic Server only
INSTALL_TYPE=WebLogic Server

# Components to install (minimal WebLogic)
SELECTED_LANGUAGES=en
DECLINE_SECURITY_UPDATES=true
```
**Now Run silent install using a response file (response_file.rsp):**
Note that the below has the weblogic jar file, make sure its path is absolute, all paths in this command should be absolute
```
# Example response file path: /home/toluwa/weblogic/core_weblogic/response_file.rsp
java -jar /home/toluwa/weblogic/fmw_15.1.1.0.0_wls_generic.jar -silent -responseFile /home/toluwa/weblogic/response_file.rsp
```



4. Verify the installation
`ls -l /home/toluwa/weblogic/middleware/`
- You should see directories like `wlserver`, `oracle_common`, `coherence`, etc.

## 4️⃣ Create WebLogic Domain
1. Create WLST Python script like `/home/toluwa/scripts/create_domain.py`, and obviously pthon should be installed or i think it isntalls it idk:
```
# create_domain.py
from java.io import File
from weblogic.management.configuration import *
from wlstModule import *

domain_path = '/home/toluwa/weblogic/domains/base_domain'
admin_user = 'wluser1'
admin_pass = 'wluser123'

# Create domain from template
readTemplate('/home/toluwa/weblogic/middleware/wlserver/common/templates/wls/wls.jar')
cd('Servers/AdminServer')
set('Name','AdminServer')
cd('/')
cd('Security/base_domain/User/weblogic')
cmo.setName(admin_user)
cmo.setPassword(admin_pass)
writeDomain(domain_path)
closeTemplate()
print("DOMAIN CREATED SUCCESSFULLY at " + domain_path)
```
in the above you can change the`admin_user='wluser1'`and`admin_pass='wluser123'`

2. Run WLST
```
/home/toluwa/weblogic/middleware/oracle_common/common/bin/wlst.sh /home/toluwa/scripts/create_domain.py
```
3. Verify the domain
`ls -l /home/toluwa/weblogic/domains/base_domain/`

## 5️⃣ [Optional] Firewall Access
If the server does not start it might be firewall issues, you will need to add the port
```
sudo firewall-cmd --add-port=7001/tcp --permanent
sudpre firewall-cmd -reload
```


## 6️⃣ Start Admin Server
```
cd /home/toluwa/weblogic/domains/base_domain/bin
./startWebLogic.sh
```
- Output should indicate server running on port 7001.
- Logs available at: 
`/home/toluwa/weblogic/domains/base_domain/servers/AdminServer/logs/AdminServer.log.`


## 7️⃣ Access WebLogic Remote Console
WebLogic 15.1.1 does not use the old console. You need the Remote Console.
I used this site to get it

https://blogs.oracle.com/blogbypuneeth/download-and-install-weblogic-remote-console-wrc

but if you dont wanna read you can just click this link for it\
https://github.com/oracle/weblogic-remote-console/releases/download/v2.4.12/WebLogic-Remote-Console-2.4.12-win.exe

Note that link is for the Remote Console App for windows



