## Loops Mini-Challenge

**PART 1-** Take the playbook below and use the `nineties` variable with your `file` task. Create all the directories using a for loop. Only one task is allowed!  
**SUPER BONUS-** Can you make all the directories lowercase?

```yaml
- name: making dirs
  hosts: bender
  connection: local
  gather_facts: no

  vars: 
    nineties:
      - Teenage
      - Mutant
      - Ninja
      - Turtles
      
  tasks:

  - name: Making directories from a list
    file:
      path: # add the item keyword!
      state: directory
    # add the loop keyword!
```



**PART 2-** Take the playbook below and edit the `msg` parameter so that it takes the `name` and `groups` value from each dictionary to complete the sentence.

```yaml
- name: looping dictionaries
  hosts: localhost
  connection: local
  gather_facts: no

  tasks:

  - name: Loop across complex data structures
    debug:
      msg: # complete this line. Make it read "A _____ is my favorite ____!"
    loop:
      - { name: 'banana', groups: 'fruit' }
      - { name: 'rousing game of Monopoly', groups: 'pastime' }
      - { name: 'cookie', groups: 'snack' }
      - { name: 'carrot', groups: 'vegetable' }
```

<!--
SOLUTION
```
- name: looping dictionaries
  hosts: localhost
  connection: local
  gather_facts: no

  tasks:

  - name: Loop across complex data structures
    debug:
      msg: "A {{ item.name }} is my favorite {{ item.groups }}!"
    loop:
      # what is returned is rep. by "item"
      - { name: 'banana', groups: 'fruit' }
      - { name: 'rousing game of Monopoly', groups: 'pastime' }
      - { name: 'cookie', groups: 'snack' }
      - { name: 'carrot', groups: 'vegetable' }
```
-->
