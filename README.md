# Project Lab 1 - ECE 3331 - Spring 2022
### This repository contains all the code, hardware design, and other important things we used the Robotics project.
The task of this project was to create a Rover which targeted an "enemy" that had a 1kHz Red LED and to "detain" the target by shooting a rubber band. There were also "friendly" targets that had a 300Hz Blue LED, which had to be avoided. The targeting was done using OSRAM SFH 309 5/6 phototransistors, which were used to detect the frequency of the LEDs. The target type had to be displayed on a seven segment display which was built in to the Basys 3 FPGA which was the brain of the Rover. This all needed to happen while the Rover followed a track of metallic tape, which we followed using HW201 infrared sensors. A PCB was designed which broke out the 9V battery into 5V and 3V3 power, and also contained an LM393 comparator which connected to the current sensing resistors of the H-Bridge and stopped the Rover when the current was detected to reach more than 1A. The code was written in SystemVerilog, but nearly identical to normal Verilog.

### Unresolved issues for anyone who comes across this
 - We forgot pull-up resistors for the LM393, so the comparator did not actually function. Include 10k resistors in parallel with the output lines tied to the same power rail as the output voltage to fix.
    - Because of this, the comparator signal is commented out on the driving controller code, so you can recomment it and add it to the if statement to check if the signal is triggered or not.
 - The 3D printed gear stripped from testing, so print multiple gears or stronger gears.
 - The 5V power supply overheated after extended use, recommend replacing with a surface mount version that is soldered to the GND plane of the circuit.
    - Try and do the entire thing in surface mount if possible. It may cost more but you can possibly get JLCPCB to build the board for you, and soldering surface mount components by hand is easy IF you remember to order a stencil.
 - Technically the servo is meant to be driven at 50Hz, not 400Hz, however we couldn't get it to work like that so we used 400Hz.
 - Try and make testbenches for all the SystemVerilog.
