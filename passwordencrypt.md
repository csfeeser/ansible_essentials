```python
from cryptography.fernet import Fernet

# Generate a key and write it to a file
key = Fernet.generate_key()
with open("secret.key", "wb") as key_file:
    key_file.write(key)

# Initialize the Fernet object with the key
cipher_suite = Fernet(key)

# Encrypt the password
password = "alta3"
cipher_text = cipher_suite.encrypt(password.encode())

# Write the encrypted password to a file
with open("password.enc", "wb") as enc_file:
    enc_file.write(cipher_text)

print(f"Encrypted password: {cipher_text}")
```

```python
"""Alta3 Research | RZFeeser
   Using netmiko to connect to many different devices to issue 'show arp' """

from datetime import datetime
from cryptography.fernet import Fernet
from netmiko import ConnectHandler

# Function to read the encryption key
def load_key():
    with open("secret.key", "rb") as key_file:
        return key_file.read()

# Function to decrypt the password
def decrypt_password():
    key = load_key()
    cipher_suite = Fernet(key)
    with open("password.enc", "rb") as enc_file:
        encrypted_password = enc_file.read()
    decrypted_password = cipher_suite.decrypt(encrypted_password).decode()
    return decrypted_password

# Read and decrypt the password from the file
password_arista = decrypt_password()

arista1 = { 
    'device_type': 'arista_eos',
    'host': 'sw-1',
    'username': 'admin',
    'password': password_arista,
}

arista2 = { 
    'device_type': 'arista_eos',
    'host': 'sw-2',
    'username': 'admin',
    'password': password_arista,
}

cisco3 = { 
    'device_type': 'cisco_ios',
    'host': '192.168.1.1',  # Use IP address for the example
    'username': 'admin',
    'password': 'cisco123',  # Plain text for the example
}

all_devices = [arista1, arista2, cisco3]

# When our script begins, get the start time
start_time = datetime.now()

# Loop across the dictionaries
for a_device in all_devices:
    try:
        net_connect = ConnectHandler(**a_device)  # Unpack the dictionary
        output = net_connect.send_command("show arp", read_timeout=10)  # Command with timeout

        # Window dressing showing the results
        print(f"\n\n--------- Device {a_device['host']} ---------")
        print(output)
        print("--------- End ---------")
    except Exception as e:
        print(f"\n\n--------- Device {a_device['host']} ---------")
        print(f"Error: {e}")
        print("--------- End ---------")

# Get the stop time
end_time = datetime.now()

# Display the total time it took
total_time = end_time - start_time
print(f"\nFinished in {total_time} seconds")
```
