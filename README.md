# ATM-SAFE-ROOM-SYSTEM-VERILOG
ATM SAFE ROOM SYSTEM VERILOG
This project implements a Finite State Machine (FSM) in Verilog to simulate an ATM Secure Room System. The system controls access to a room, allowing a person to enter after inputting a correct password and denying entry if the room is already occupied. The design is inspired by real-life secure access systems, such as ATM rooms or vaults, where only one person is allowed entry at a time.

Features
State-based Access Control: The system allows access only when the correct password is entered.
Single-Person Occupancy: If one person is inside the room, any other person trying to enter will be denied access.

Visual Feedback:
Green LED indicates access is granted.
Red LED indicates waiting or wrong password input.
7-Segment Display:
En for entry
OK for successful entry
EE for incorrect password

Finite State Machine (FSM)
The system operates in the following states:

IDLE: The system waits for someone to approach and trigger the entry sensor.\n
WAIT_PASSWORD: Once a person is detected, the system prompts for a password and waits for the input.\n
RIGHT_PASS: If the correct password is entered, access is granted, and the person can enter.\n
WRONG_PASS: If the wrong password is entered, access is denied, and the system remains in this state until the correct password is entered./n
STOP: If a person is already inside the room, any other person attempting to enter will be denied until the room becomes available./n
![image](https://github.com/user-attachments/assets/2ee07f64-0c0b-4bf1-96b1-8a66cec9e5a1)
