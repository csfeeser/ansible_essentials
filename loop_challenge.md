```
- name: looping dictionaries
  hosts: localhost
  connection: local
  gather_facts: no

  vars:

  tasks:

  - name: Loop across complex data structures
    debug:
      msg: # complete this line. Make it read "A _____ is my favorite ____!"
    loop:
      - { name: 'orange', groups: 'fruit' }
      - { name: 'lemon', groups: 'fruit' }
      - { name: 'cookie', groups: 'snack' }
      - { name: 'carrot', groups: 'vegetable' }
```

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
      - { name: 'orange', groups: 'fruit' }
      - { name: 'lemon', groups: 'fruit' }
      - { name: 'cookie', groups: 'snack' }
      - { name: 'carrot', groups: 'vegetable' }
```
