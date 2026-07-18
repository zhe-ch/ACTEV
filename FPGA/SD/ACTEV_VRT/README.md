# BOOT file for ACTEV [Virtual Sensor]
This BOOT.bin file provides a compiled firmware that works with a virtual sensor on the FPGA based on the Ultra96 platform.

The FPGA IP address is configured as:
Board IP: 192.168.1.10
Netmask:  255.255.255.0
Gateway:  192.168.1.1

Tips:
1. Disable WIFI for best performance with the test.
2. Wait for a few seconds before starting the test. You can open a command prompt and test with Ping to test the ethernet connection before starting the experiments with ACTEV.

>ping 192.168.1.10
You're looking for following feedback:
Reply from 192.168.1.10: bytes=32 time<1ms TTL=255
Reply from 192.168.1.10: bytes=32 time<1ms TTL=255
Reply from 192.168.1.10: bytes=32 time<1ms TTL=255
Reply from 192.168.1.10: bytes=32 time<1ms TTL=255

This indicates that the Ethernet connection has been established successfully.
