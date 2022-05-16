#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2016.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 339ff6d1cec245b389e5a7720629d9dd -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot test_behav xil_defaultlib.test -log elaborate.log
