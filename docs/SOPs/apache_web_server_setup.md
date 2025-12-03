# Apache Setup Guide

## Step 1 - Install Apache
`sudo yum install httpd -y`

## Step 2 - Start and enable services
`systemctl start httpd`
`systemctl enable httpd`
`systemctl status httpd`

## Step 3 - Allow HTTP through firewall
`firewall-cmd --add-service=http --permanent`
`firewall-cmd --reload`

## Step 4 - Create Website Directory and HTML Page
`mkdir -p /var/www/html/mysite`
put in your website content in the file below
`vi /vr/www/html/your_site/your_site.html`

## Step 5 - Set Ownerships and permissions (Optional)
`chown -R apache:apache /var/www/html/your_site`
`chown -R 755 /var/www/html/your_site`

## Step 6 - Create a Virtual Host Configuration
`vi /etc/httpd/conf.d/your_site.conf`
and paste the below in the above
`<VirtualHost *:80>`
    `ServerAdmin admin@example.com`
    `DocumentRoot /var/www/html/your_site`
    `ServerName your_site.local`
    `ErrorLog /var/log/httpd/your_site-error.log`
    `CustomLog /var/log/httpd/your_site-access.log combined`
`</VirtualHost>`
save and exit

## Step 7 Restart Apache
`systemctl restart httpd`

## Step 8 Test 
enter in the site as
`http://<your-sever-ip-address>`

## Notes, How it works
 - **Apache (httpd)** → The web server software that servers the web page
 - **`/var/www/html`** → Defualt directories for the website
 - **`DocumentRoot`** → Tellls Apache where your files are located
 - **`VirtualHost`** → Allows hosting multiple websites on one server
 - **`conf.d`** → Directory where Apache loads additonal site configs
