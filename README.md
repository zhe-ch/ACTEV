# Accelerator for Calcium Trace Extraction from Video (ACTEV)

## 1. FPGA and Embedded Software

The ACTEV was built on top of the [Ultra96 Platform](https://www.96boards.org/product/ultra96/).

### 1.1 FPGA

Please refer to bitstream and Xilinx Support Archive (XSA) files under [./FPGA/Vivado/](FPGA/Vivado).
The precompiled FPGA image is under [./FPGA/SD/](FPGA/SD). You could simply rely on the image to boot the FPGA and run ACTEV under the SD mode.

### 1.2 Embedded Software

Source code for the embedded software is under [./FPGA/Vitis/actev_program/](FPGA/Vitis/actev_program).
If you would like to rebuild the embedded software in [Vitis](https://www.xilinx.com/products/design-tools/vitis/vitis-platform.html), please remember to include the [./FPGA/Vitis/EmbeddedSw/](FPGA/Vitis/EmbeddedSw) in your project local directory. 

## 2. PCB

The interface PCB sits on top of the Ultra96 board.
It provides Ethernet connection to a host PC and a 14-pin flywire connection to the [Data Acquisition Box (DAQ)](http://miniscope.org/index.php/Data_Acquisition_Box).
Fabrication files are under [./PCB/](PCB).

## 3. Simulation

Matlab and C programs can simulate ACTEV behaviors at high level accurately.

### 3.1 Matlab

We provide 3 sets of Matlab scripts for analyzing calcium image data offline: 

1) [Motion Correction](Simulation/Matlab/MotionCorrect): Frame-based rigid motion correction. 
2) [Trace Extraction](Simulation/Matlab/TraceExtraction): Separate files supporting cell and tile based trace extraction.
3) [Linear Classifier Training](Simulation/Matlab/TrainLinearClassifier): Provide training and inference code for the linear classifier.

### 3.2 C Program

We also provide following C programs as a behavioral simulation model for ACTEV:

1) [Extract Classifier Parameter](Simulation/C/getClassifyParam): Convert Matlab generated linear classifier parameters into loadable binary file for ACTEV.
2) [Extract Template](Simulation/C/getMeanAsTml): Extract mean of recorded images as a template for the motion correction C simulation.
3) [Linear Classifier Inference](Simulation/C/linearClassify): Perform simulation of the position decoding based on linear classifier parameters.
4) [Motion Correction](Simulation/C/rigidMC): Frame-based rigid motion correction.
5) [Trace Extraction](Simulation/C/simTracer): Support cell and tile based trace extraction, with provided example contour files.

