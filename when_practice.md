## More Practice with WHEN and LOOPS!

`student@bchd~$` `vim whenpractice.yml`

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

`student@bchd~$` `ansible-playbook whenpractice.yml`

### 3 Hints and a Solution

<details>
<summary>Gimme a hint!</summary>
<br>

- Hint 1: Your name is being compared to the current `item` in the loop.

<details>
<summary>Need another hint?</summary>
<br>

- Hint 2: You'll need to confirm that your name and the current `item` are the same.

<details>
<summary>Want another hint?</summary>
<br>

- Hint 3: Use `==` to compare your name to the current `item`.

<details>
<summary>Want the answer?</summary>
<br>

- Hint 4: Use the `when` condition like this:

```yaml
    - name: Print that only YOUR name is awesome
      debug:
        msg: "{{ item }} is awesome!"
      loop: "{{ names_list }}"
      when: item == "YourName"
```

Replace "YourName" with your actual name.

</details> </details> </details> </details>
