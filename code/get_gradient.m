function [gradient] = get_gradient(network,samples,labels,learning_rate)
%get the gradient

%vectorize the old model parameters
% CVX toolbox: vec() 
network_old_vector=vec(network.IW{1,1});
for i=1:1:(size(network.b,1)-1)
    network_old_vector=[network_old_vector;vec(network.LW{i+1,i})];
end
for i=1:1:size(network.b,1)
    network_old_vector=[network_old_vector;vec(network.b{i,1})];
end
% network_old_vector=[vec(network.IW{1,1});vec(network.LW{2,1});vec(network.b{1});vec(network.b{2})];
%train the network
[network,~]=train(network,samples.',labels.');
%vectorize the new model parameters
network_new_vector=vec(network.IW{1,1});
for i=1:1:(size(network.b,1)-1)
    network_new_vector=[network_new_vector;vec(network.LW{i+1,i})];
end
for i=1:1:size(network.b,1)
    network_new_vector=[network_new_vector;vec(network.b{i,1})];
end
% network_new_vector=[vec(network.IW{1,1});vec(network.LW{2,1});vec(network.b{1});vec(network.b{2})];
%calculate the gradient
gradient=(network_old_vector-network_new_vector)/learning_rate;

end

