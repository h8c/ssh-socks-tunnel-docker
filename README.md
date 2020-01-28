
SSH SOCKS Tunnel Docker Image
=============================


[![Docker Automated build](https://img.shields.io/docker/automated/nicolasvan/ssh-socks-tunnel)](https://hub.docker.com/repository/docker/nicolasvan/ssh-socks-tunnel) [![Docker Image CI](https://github.com/nicolas-van/ssh-socks-tunnel-docker/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/nicolas-van/ssh-socks-tunnel-docker/actions?query=workflow%3A%22Docker+Image+CI%22)

This image contains a simple openssh configuration over alpine. The goal is have a straightforward way to setup a simple ssh server in order to create a SOCKS proxy. The purpose is, once again, to defeat those damn enterprise proxies that basically disallow you anything aside connecting to the crappy enterprise website.

While at home
-------------

Launch the docker container on your server:

    docker run -d -p 443:22 -e "USER_SSH_ALLOWED=*paste your ssh key here*" nicolasvan/ssh-socks-tunnel

In the above example we redirect the 22 port to 443 (HTTPS port) on our host.
The reason is that the hellish enterprise proxies we try to work around will always disallow connections to all ports except that HTTPS port.
We also add some ssh key(s) to allow a safe connexion to our SSH server.

As an alternative to redirecting/mapping the port via docker (e.g. for some scenarios like [Azure Container Instances](https://azure.microsoft.com/en-us/services/container-instances/) the optional environment variable `SSHD_PORT` can be used.

Then create a SOCKS proxy to test:

    ssh -D 1234 -p 443 -N user@*your server url*
    
Configure your browser to connect to the `localhost:1234` SOCKS proxy and test that everything works fine. You can check on [What is my ip](http://whatismyipaddress.com/) that it's your server IP which is displayed.

The last thing to do before going to work tomorrow is to install [corkscrew](https://github.com/bryanpkc/corkscrew) on your local machine. You can't configure it right now but you may not be able to download it at work, so do it in advance.

While at work
-------------

Time to setup and test corkscrew. Here is an example configuration to add to your ~/.ssh/config file (assuming you don't have credentials to add, which you will):

    ProxyCommand /usr/local/bin/corkscrew proxy.work.com 80 %h %p
    
You can quickly test the connection to your remote server using a simple ssh command:

    ssh -p 443 user@*your server url*

If it works it's a win. Just setup the SOCKS proxy and your browser the exact same way you did yesterday. You can now, finally, do you work.
