#!/usr/bin/env python3
"""
AES-128 Test Vector Verification
Verifies the NIST FIPS-197 test vectors using Python's cryptography library
"""

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend

# NIST FIPS-197 Test Vectors
PLAINTEXT = bytes.fromhex('00112233445566778899aabbccddeeff')
KEY = bytes.fromhex('000102030405060708090a0b0c0d0e0f')
EXPECTED_CIPHERTEXT = bytes.fromhex('69c4e0d86a7b0430d8cdb78070b4c55a')

def test_aes128_ecb():
    """Test AES-128 ECB encryption and decryption"""
    print("AES-128 ECB Test Vector Verification")
    print("=" * 50)
    print(f"Plaintext:  {PLAINTEXT.hex()}")
    print(f"Key:        {KEY.hex()}")
    print(f"Expected:   {EXPECTED_CIPHERTEXT.hex()}")
    print()
    
    # Encryption
    cipher = Cipher(algorithms.AES(KEY), modes.ECB(), backend=default_backend())
    encryptor = cipher.encryptor()
    ciphertext = encryptor.update(PLAINTEXT) + encryptor.finalize()
    
    print(f"Computed:   {ciphertext.hex()}")
    if ciphertext == EXPECTED_CIPHERTEXT:
        print("ENCRYPTION: PASSED")
    else:
        print("ENCRYPTION: FAILED")
    print()
    
    # Decryption
    decryptor = cipher.decryptor()
    decrypted = decryptor.update(ciphertext) + decryptor.finalize()
    
    print(f"Decrypted:  {decrypted.hex()}")
    print(f"Expected:   {PLAINTEXT.hex()}")
    if decrypted == PLAINTEXT:
        print("DECRYPTION: PASSED")
    else:
        print("DECRYPTION: FAILED")
    print()
    print("=" * 50)
    
    return ciphertext == EXPECTED_CIPHERTEXT and decrypted == PLAINTEXT

if __name__ == '__main__':
    success = test_aes128_ecb()
    exit(0 if success else 1)