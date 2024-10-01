## More Practice with WHEN and LOOPS!

```yaml
---
- name: When and Loops
  hosts: localhost
  vars:
    names_list:
      - Chad
      - Damian
      - Jason

  tasks:
    - name: Print that only YOUR name is awesome
      debug:
        msg: "{{ item }} is awesome!"
      loop: "{{ names_list }}"
      # CHALLENGE: Add a `when` condition here that this task only prints out YOUR name as awesome :)
```

#### Solution (click to reveal)

<details>
  <summary>Solution</summary>

```yaml
- name: Warmup Activity: Only Print Your Name as Awesome!
  hosts: localhost
  vars:
    names_list:
      - Chad
      - Damian
      - Jason

  tasks:
    - name: Print that only YOUR name is awesome
      debug:
        msg: "{{ item }} is awesome!"
      loop: "{{ names_list }}"
      when: item == "YourName"
```

Replace `"YourName"` with your actual name.
</details>
