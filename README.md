# Accelerator for Calcium Trace Extraction from Video (ACTEV)

<img width="341" height="341" alt="image" src="https://github.com/user-attachments/assets/a319fdde-185d-4a98-b0e4-676667bb43cd" />


## 1. FPGA and Embedded Software

The ACTEV was built on top of the [Ultra96 Platform](https://www.96boards.org/product/ultra96/).

### 1.1 FPGA

Please refer to Xilinx Support Archive (XSA) files under [./FPGA/Vivado/](FPGA/Vivado).
The precompiled FPGA image is under [./FPGA/SD/](FPGA/SD). You could simply rely on the image to boot the FPGA and run ACTEV under the SD mode.
This directory contains two separate image files, located in [./Linear_Classifier](FPGA/SD/Linear_Classifier) and [./Tree-Based_Classifier](FPGA/SD/Tree-Based_Classifier) sub folders.

### 1.2 Embedded Software

Source code for the embedded software is under [./FPGA/Vitis/](FPGA/Vitis). Embedded software with linear classifier and tree-based classifier functions are arranged in separate projects.

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

## 4. RTI Interface

We developed real-time interface (RTI) in C# to support user interaction with ACTEV.
Source code of the RTI development is under [./Software/](Software).
Example loadable files for the RTI are collected under [./Software/file/](Software/file):

1) [Cell Contour](Software/file/contour): cell/tile contour in text/binary and other parameter files in text format.
2) [Filter Kernel](Software/file/filter): Constant 17x17 Gaussian contrast filter kernel in binary format.
3) [Template](Software/file/template): Example 128x128 template image for motion correction in text format.


## 5. Publication

[1] Z. Chen, G. J. Blair, C. Guo, J. Zhou, J.-L. Romero-Sosa, A. Izquierdo, P. Golshani, J. Cong, D. Aharoni, and H. T. Blair, "A Hardware System for Real Time Decoding of In Vivo Calcium Imaging Data". eLife, 12:e78344, 2023.

[2] Z. Chen, G. J. Blair, C. Cao, J. Zhou, D. Aharoni, P. Golshani, H. T. Blair, and J. Cong. "FPGA-Based In-Vivo Calcium Image Decoding for Closed-Loop Feedback Applications". IEEE Transactions on Biomedical Circuits and Systems. Volume 17, Issue 2, pp. 169-179, 2023.
