function data = fw_snap(dcam)% FW_SNAP Acquire a frame from a Firewire camera.%%   data = fw_snap(dcam) acquires a single data frame from a digital camera%   dcam that was previously initialized using fw_init.data = double(getsnapshot(dcam));