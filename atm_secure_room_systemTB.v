`timescale 1ns / 1ps
// Testbench for ATM Secure Room System with one person scenario
module tb_atm_secure_room_system;

  // Inputs
  reg clk;
  reg reset_n;
  reg sensor_entry;
  reg sensor_exit;
  reg [1:0] passcode_digit_1;
  reg [1:0] passcode_digit_2;

  // Outputs
  wire GREEN_LIGHT;
  wire RED_LIGHT;
  wire [6:0] DISPLAY_1;
  wire [6:0] DISPLAY_2;

  // Instantiate the Unit Under Test (UUT)
  atm_secure_room_system uut (
    .clk(clk), 
    .reset_n(reset_n), 
    .sensor_entry(sensor_entry), 
    .sensor_exit(sensor_exit), 
    .passcode_digit_1(passcode_digit_1), 
    .passcode_digit_2(passcode_digit_2), 
    .GREEN_LIGHT(GREEN_LIGHT), 
    .RED_LIGHT(RED_LIGHT), 
    .DISPLAY_1(DISPLAY_1), 
    .DISPLAY_2(DISPLAY_2)
  );

  // Clock Generation
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // Clock period of 20 ns
  end

  // Monitor to print state changes and output signals
  initial begin
    $monitor("Time: %0t | State: %0b | GREEN_LIGHT: %b | RED_LIGHT: %b | DISPLAY_1: %b | DISPLAY_2: %b",
              $time, uut.current_state, GREEN_LIGHT, RED_LIGHT, DISPLAY_1, DISPLAY_2);
  end

  // Dump waveforms for EDA Playground
  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0, tb_atm_secure_room_system); // Record all variables
  end

  // Stimulus for one-person scenario
  initial begin
    // Initialize Inputs
    reset_n = 0;
    sensor_entry = 0;
    sensor_exit = 0;
    passcode_digit_1 = 0;
    passcode_digit_2 = 0;

    // Wait 100 ns for global reset to finish
    #100;
    reset_n = 1; // Release reset

    // Person Approaches (Triggers Entry Sensor)
    #20; 
    sensor_entry = 1; // Person approaches the door
    
    #100; // Wait for entry sensor to detect

    // Person enters the correct password
    sensor_entry = 0;
    passcode_digit_1 = 2'b01; // Entering correct password (01)
    passcode_digit_2 = 2'b10; // Entering correct password (10)

    #200; // Wait for system to verify password and grant access

    // Person stays in the room for a bit
    #500;

    // Person Exits (Triggers Exit Sensor)
    sensor_exit = 1; // Person leaves the room

    #50;
    sensor_exit = 0; // Exit complete

    // End the simulation after all actions are complete
    #500;
    $finish;
  end

endmodule
