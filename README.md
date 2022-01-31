# Accelerator for Calcium Trace Extraction from Video (ACTEV)

## 1. FPGA and Embedded Software

The ACTEV was built on top of the [Ultra96 Platform](https://www.96boards.org/product/ultra96/)

### 1.1 FPGA

Please refer to bitstream and Xilinx Support Archive (XSA) files under [./FPGA/Vivado/](FPGA/Vivado).
The precompiled FPGA image is under [./FPGA/SD/](FPGA/SD). You could simply rely on the image to boot the FPGA and run ACTEV under the SD mode.

### 1.2 Embedded Software

Source code for embedded software of ACTEV is under [./FPGA/Vitis/actev_program](FPGA/Vitis/actev_program).
If you would like to rebuild the embedded software in [Vitis](https://www.xilinx.com/products/design-tools/vitis/vitis-platform.html), please remember to include the [./FPGA/Vitis/EmbeddedSw/](FPGA/Vitis/EmbeddedSw) in your project local directory. 



