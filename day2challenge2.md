## Recap Challenge

The following will give you a chance to write some new code that uses techniques you've learned in class so far!

1. Edit your inventory file. Create a new group:

    ```
    [looneytunes]
    bugs        ansible_host=10.10.2.3 ansible_user=bender ansible_python_interpreter=/usr/bin/python3
    taz         ansible_host=10.10.2.4 ansible_user=fry ansible_python_interpreter=/usr/bin/python3
    daffy       ansible_host=10.10.2.5 ansible_user=zoidberg ansible_python_interpreter=/usr/bin/python3
    ```
    
0. **OPTIONAL:** Use the `ping` module in an ad hoc command to test that you added those hosts correctly!

0. Write a new playbook that uses `looneytunes` as hosts. Have your playbook do the following:
    - Create a new directory in each machine called `~/challenge`
    - Download the `downloadme.txt` file located at the following address and save it to the `~/challenge` directory you just made.
      `https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/downloadme.txt`

0. Run lab 23, learn how the "lineinfile" and "replace" modules work.

0. Using what you learned in lab 23, replace the string "PLACEHOLDER" in the downloadme.txt file with your own name!

