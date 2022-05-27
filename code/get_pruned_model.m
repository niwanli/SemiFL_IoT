function [network_pruned,prune_index] = get_pruned_model(network,prune_rate,Q)
%prune the local model

%vectorize the old model parameters
network_old_vector=vec(network.IW{1,1});
for i=1:1:(size(network.b,1)-1)
    network_old_vector=[network_old_vector;vec(network.LW{i+1,i})];
end
for i=1:1:size(network.b,1)
    network_old_vector=[network_old_vector;vec(network.b{i,1})];
end

%prune
%sort the absolute values of the entries
[~,index_all]=sort(abs(network_old_vector),"ascend");
% %get the prune threshold
% prune_threshold=network_temp(ceil(Q*prune_rate),1);
%get the indexes of pruning
prune_index=index_all(1:ceil(Q*prune_rate));
%prune
network_old_vector(prune_index,1)=0;
%sort prune index in ascending order
prune_index=sort(prune_index,"ascend");

%reload the local model
start_point=0;
network.IW{1,1}=reshape(network_old_vector(start_point+1:start_point+size(vec(network.IW{1,1}),1)),size(network.IW{1,1}));
start_point=start_point+size(vec(network.IW{1,1}),1);
for i=1:1:(size(network.b,1)-1)
    network.LW{i+1,i}=reshape(network_old_vector(start_point+1:start_point+size(vec(network.LW{i+1,i}),1)),size(network.LW{i+1,i}));
    start_point=start_point+size(vec(network.LW{i+1,i}),1);
end
for i=1:1:size(network.b,1)
    network.b{i}=reshape(network_old_vector(start_point+1:start_point+size(vec(network.b{i}),1)),size(network.b{i}));
    start_point=start_point+size(vec(network.b{i}),1);
end
network_pruned=network;

end