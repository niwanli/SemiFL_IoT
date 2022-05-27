function [selected_FL_index] = get_selected_FL_devices(gradient_FL,K_f_selected)
%select the best K_f_selected FL devices
%select
gradient_norms=zeros(size(gradient_FL,2),1);
for k=1:1:size(gradient_norms,1)
    gradient_norms(k,1)=norm(gradient_FL(:,k));
end
%find the indexes of the largest num_best norms
[~,index_temp]=sort(gradient_norms,'descend');
selected_FL_index=index_temp(1:K_f_selected);
selected_FL_index=sort(selected_FL_index,"ascend");

end