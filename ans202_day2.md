## Busted Playbook Challenge!

<img src="https://i.redd.it/i4v9op0chrc51.jpg" width="500"/>


Good morning! To get the blood moving today we'll start with a playbook using some familiar tools-- however, it's broken! Your job is to get it working (no need to improve it).

Copy/paste the broken playbook below. There are SEVEN errors total! Fix, test, repeat!

```yaml
---
- name: Retrieve a random Simpsons quote and assert its Homer
  hosts: localhost
  connection: network_cli
  gather_facts: no

  taskz:
    - name: Read a quote from The Simpsons API
      uri:
        url: https://thesimpsonsquoteapi.glitch.me/quotes?character=simpson
        method: POST
        return_content: yes
      register: quote_response

    - name: Print the quote data received
      debug:
        var: quote_response.json[0]

    - name: Display the ONLY the quote
      debug:
        msg: "quote_response.json[0].quote"

    - name: Assert the quote is from Homer Simpson
      assert:
        when: quote_response.json[0].character == "Homer Simpson"
          fail_msg: "Not a Homer quote. D'oh!"
          success_msg: "This IS a Homer quote. WOO-HOO!"
```

<details>
<summary>Click here for the solution!</summary>
<br>

```yaml
---
- name: Retrieve a random Simpsons quote and assert its Homer
  hosts: localhost
  connection: local                                                  # USE THE LOCAL CONNECTION WHEN USING LOCALHOST AS A HOST
  gather_facts: no

  tasks:                                                             # SPELLED 'tasks,' NOT 'taskz'
    - name: Read a quote from The Simpsons API
      uri:
        url: https://thesimpsonsquoteapi.glitch.me/quotes?character=simpson
        method: GET                                                  # WE ARE READING, NOT CREATING-- USE GET REQUEST!
        return_content: yes
      register: quote_response

    - name: Print the quote data received
      debug:
        var: quote_response.json[0]

    - name: Display the ONLY the quote
      debug:
        msg: "{{ quote_response.json[0].quote }}"                    # GOT TO USE {{ CURLY BRACES }} TO RETURN VALUE OF A VARIABLE

    - name: Assert the quote is from Homer Simpson
      assert:
        that: quote_response.json[0].character == "Homer Simpson"    # ASSERT USES 'THAT' TO DECLARE ITS CONDITION, NOT 'WHEN'
        fail_msg: "Not a Homer quote. D'oh!"                         # CONSISTENT INDENTATION IS KEY! BOTH THIS LINE AND
        success_msg: "This IS a Homer quote. WOO-HOO!"               # THIS ONE MUST BE ALIGNED WITH THE FIRST PARAMETER
```

</details>
