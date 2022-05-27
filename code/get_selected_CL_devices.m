function [selected_CL_index] = get_selected_CL_devices(channel_all,K_f,K_c_selected)
%select the best K_c_selected CL devices for CL

%get the channel coefficients of CL devices
channel_CL=channel_all(K_f+1:end,1);
channel_CL=abs(channel_CL);
[~,index_temp]=sort(channel_CL,"descend");
selected_CL_index=index_temp(1:K_c_selected);
selected_CL_index=sort(selected_CL_index,"ascend");

end