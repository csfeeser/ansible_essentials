## Jinja2 Morning Warmup!

Using the template module in Ansible, there are MANY things we can render with Jinja! A practical example might be something like a switch config. Using the text below, create a new template that will contain a Cisco IOS switch configuration template.

`student@bchd:~$` `mkdir -p ~/ans/templates/`

`student@bchd:~$` `vim ~/ans/templates/baseIOS.conf.j2`

```
!=== {{ switchname }} ===!

!--- IOS config ---!
enable
configure terminal
hostname {{ switchname }}

!--- MGMT ---!
username {{ username }} secret alta3
ip route 0.0.0.0 0.0.0.0 {{ defaultgateway }}
interface Management 1
ip address {{ switchIP }} {{ netmask }}
mtu {{ mtusize }}
exit

!--- SSH ---!
management ssh
  idle-timeout 0
  authentication mode keyboard-interactive
  server-port 22
  no fips restrictions
  no hostkey client strict-checking
  no shutdown
  login timeout 120
  log-level info
exit
exit
write memory
```

Now create a file that will contain the data you pass to this template!

`student@bchd:~$` `mkdir -p ~/ans/vars/`

`student@bchd:~$` `vim ~/ans/vars/challengevars.yml`

```
---
switchname: sw_1
username: admin
defaultgateway: 5.6.7.8
switchIP: 1.2.3.4
netmask: 255.255.255.0
mtusize: 1450
```

### THE CHALLENGE

Create a playbook that uses the template module. Populate the switch config file above with data from `challengevars.yml`!

#### BONUS

Make the new file's name unique! Include the name of the switch somewhere in the file name.

#### SUPER BONUS

Suppose one of the keys is not provided (such as, there is no value for `mtusize` or `switchIP`). Figure out a way to pass a *default* value instead! It doesn't matter what the default value is. You can test this by removing one of the lines from `challengevars.yml`.
