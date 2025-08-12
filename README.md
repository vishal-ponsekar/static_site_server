# static_site_server
Setup a basic linux server and configure it to serve a static site.

### Steps I Followed
- First, created an Ubuntu server to act like a local server in AWS.
- Next, created another Ubuntu server to act like a remote server in AWS.
- Then, installed nginx on remote server.
- After, I copied the static website in the remote server, which I created when I learned HTML and CSS from scrimba.
- And removed the index.html file from the /var/www/html folder and used the static website index.html file.
- After that, I am able to see the static website using the public IP of the remote server.
- From the problem statement, we need to push files from the local server to the remote server using rsync.
- But I already directly push the code to remote server. Now, I decided to pull the code from remote to local. After, edit and push the code from local to remote.
- To pull the code, I need to enable SSH config. So, I created SSH key pair locally and shared the public key with remote server.
- Then, I pull the code by running the following rsync command in the local server.
```bash
	rsync -a ubuntu@<remote_server_public_ip>:/var/www/html/ website/
```
- Next, I did some changes in the code in the local server and tried to push the code to the remote server using the following command.
```bash
	rsync -a website/ ubuntu@<remote_server_public_ip>:/var/www/html
```
- But I got a permission denied error. So, I logged in to the remote server trying to find out the nginx.conf file to change the location of the website. Because the /var/www/html directory needs root user access. So, I tried to point out the website in the home directory.
- I checked the file path in the nginx.conf file but it doesn't contain anything like that. And I saw a directory called sites-available in the nginx directory. I cd to sites-available there I see the default file there I find the path. I changed the path to the home directory. Then, check it's modified or not in the website but it still working. So, I restarted the nginx. Now, it shows 404 not found. Because, I didn't move the website file. Currently the website directory is empty that's why it shows 404.
	default path config file location in ubuntu: /etc/nginx/sites-available/default

- Then, pushed the code from local to remote server using following command.
```bash
	rsync -aP website/ ubuntu@<remote_server_public_ip>:/home/ubuntu/website
```
- After, I checked the site by using remote server public ip it shows 404 error. Next, I restarted the nginx to check it will  help or not. But, still the site been down.
- Then, checked the error in /var/log/nginx/error.log file. It shows permission denied error. Again, asked this doubt to perplex it suggest the error should be in permission of the file or the path should be wrong.
- So, I decided to change the file permissions by chmod command.

**What is the problem I'm facing now?**<br>
Initially in the rsync push code from local server to remote server we got permission denied. So, I changed the file location in /etc/nginx/sites-available/default file from /var/www/html to /home/ubuntu/website.
Now, the nginx user is www-data to check this we can see on nginx.conf file. And the /home/ubuntu/website have all access by the ubuntu user.  The www-data don't have access to this website folder. That's why we got the 404 error and permission denied. And perplex suggests chown command to access for www-data user. But, it will change the ownership from ubuntu user to www-data. And it suggests chmod command and allow permissions by 755. I did that that's also didn't work.
Even, I changed the ownership from ubuntu to www-data for website folder and the files inside the folder. Still I got permission denied error and 404 not found. This time perplex suggests www-data user has permission in website folder but for traversal from /home/ubuntu it needs permission from there also. And I checked the directory permission other users didn't have access in ubuntu folder. I believe that's the reason for nginx receive permission denied error.
Because, of the permission of ubuntu folder even we changed the permissions of website folder the nginx user can't able to access.

- By default the ubuntu folder don't have any access to other users in ubuntu folder. Once we allow read and execute permission for other users the nginx get the application. Now the website is working.
- It's time to check the rsync command again. I modified the code in local server. Then, I tried to push the code in remote server using rsync. But, I got "failed: Operation not permitted".

**Note:**
Now, I understand why I got this error. Because, in the /home/ubuntu/website folder we didn't allow write permission for other users. This is the same reason for why we can't update the code in /var/www/html also.

- To remove this error. I started to create new directory and changed the file location from /home/ubuntu/website to /static-site in available-sites/default file.
- And allowed write access to other users in new directory. Now, I got 403 forbidden error in the browser.
- After, I pushed the code from local server to remote server successfully. The site is up and running.
- Then, wrote a script deploy.sh file to use rsync to sync the files in local to remote server.
- And, whenever I made changes in the code of local and I want to push the code in remote I use this script to sync the files in local to remote server.
- Kindly ensure you got permission to run the script in your system.
- Now, the site is up and running.

### Project Description URL
https://roadmap.sh/projects/static-site-server
