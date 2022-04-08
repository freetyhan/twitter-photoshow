#!/bin/sh
echo 0 >/sys/class/fpga-bridge/fpga2hps/enable
echo 0 >/sys/class/fpga-bridge/hps2fpga/enable
echo 0 >/sys/class/fpga-bridge/lwhps2fpga/enable


dd if=/media/fat_partition/vga_15.rbf of=/dev/fpga0 bs=1M

echo 1 >/sys/class/fpga-bridge/fpga2hps/enable
echo 1 >/sys/class/fpga-bridge/hps2fpga/enable
echo 1 >/sys/class/fpga-bridge/lwhps2fpga/enable
