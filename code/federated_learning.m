% Baseline 2: Federated Learning

clear all

%load dataset
load('Fashion_MNIST\non_iid_samples.mat');
load('Fashion_MNIST\non_iid_labels.mat');
load('Fashion_MNIST\train_data_all.mat');
load('Fashion_MNIST\train_label_all.mat');
load('Fashion_MNIST\test_data_all.mat');
load('Fashion_MNIST\test_label_all.mat');

%%
number_of_neuron=[50 100 50];

Q=0;
network_imaginary=[784,number_of_neuron,10];
for i=2:1:size(network_imaginary,2)
    Q=Q+(network_imaginary(1,i-1)+1)*network_imaginary(1,i);
end

FL_round=1000;

K=10;
K_f=6;
K_c=K-K_f;
K_f_selected=K_f;
K_c_selected=0;

radius_max=40;
radius_min=30;

location_all=get_locations(K,radius_min,radius_max,100);

prune_rate=0.3;

batch_ratio_FL=0.3;

N_f=ones(K_f,1);
for k=1:1:K_f
    N_f(k)=ceil(batch_ratio_FL*size(train_label{k,1},1));
end

batch_ratio_CL=0.3;

N_c=ones(K_c,1);
for k=1:1:K_c
    N_c(k)=ceil(batch_ratio_CL*size(train_label{K_f+k,1},1));
end

N_r=1;

% save training result
save_address='performance_vs_rounds\FL_with_pruning';

eta=0.1;

repeat_times=1;

%%
accuracy=zeros(FL_round,repeat_times);
loss=zeros(FL_round,repeat_times);
for st=1:1:repeat_times

global_net=patternnet(number_of_neuron);
global_net.trainFcn = 'traingd';
global_net.performFcn = 'crossentropy';
global_net.trainParam.lr=eta;
global_net.inputs{1}.processFcns={};
global_net.outputs{size(number_of_neuron,2)+1}.processFcns={};
global_net.trainParam.epochs = 1;
global_net.trainParam.showWindow = 0;
global_net.trainParam.showCommandLine= 0;
global_net=configure(global_net,train_data{1,1}(1,:).',train_label{1,1}(1,:).');

load('get_initial_model.mat');
global_net.IW{1,1}=global_net_IW{1,1};
for i=1:1:size(number_of_neuron,2)
    global_net.LW{i+1,i}=global_net_LW{i,1};
end

for i=1:1:(size(number_of_neuron,2)+1)
    global_net.b{i}=global_net_b{i,1};
end
clear global_net_IW global_net_LW global_net_b global_net_b

%%
sample_index_FL=cell(K_f,1);
sample_index_CL=cell(K_c,1);
gradient_FL=zeros(Q,K_f);
gradient_CL=zeros(Q,K_c);
channel_all=zeros(K,1);

for rd=1:1:FL_round

    channel_all=get_channels(K,N_r,location_all,FL_round*(st-1)+rd);

    fprintf(['Communiation round: ',num2str(rd),'\n'])
      
    rng(FL_round*(st-1)+rd)
    for k=1:1:K_f
        rand_index=(randperm(size(train_data{k,1},1))).';
        sample_index_FL{k,1}=rand_index(1:1:N_f(k),1).';
    end
    
    for k=1:1:K_c
        rand_index=(randperm(size(train_data{k+K_f,1},1))).';
        sample_index_CL{k,1}=rand_index(1:1:N_c(k),1).';
    end
    rng('shuffle');
    
    selected_CL_index=get_selected_CL_devices(channel_all,K_f,K_c_selected);
    train_data_CL=zeros(sum(N_c(selected_CL_index,1)),784);
    train_label_CL=zeros(sum(N_c(selected_CL_index,1)),10);
    start_point=0;
    for k=selected_CL_index.'
        train_data_CL(start_point+1:start_point+N_c(k),:)=train_data{k+K_f,1}(sample_index_CL{k,1},:);
        train_label_CL(start_point+1:start_point+N_c(k),:)=train_label{k+K_f,1}(sample_index_CL{k,1},:);
        start_point=start_point+N_c(k);
    end
    
    gradient_CL=get_gradient(global_net,train_data_CL,train_label_CL,eta);

    [global_net_FL,prune_index]=get_pruned_model(global_net,prune_rate,Q);

    for k=1:1:K_f
        gradient_FL(:,k)=get_gradient(global_net_FL,train_data{k,1}(sample_index_FL{k,1},:),train_label{k,1}(sample_index_FL{k,1},:),eta);
        gradient_FL(prune_index,k)=0;
    end

    selected_FL_index=get_selected_FL_devices(gradient_FL,K_f_selected);
    
    gradient_aggregated=zeros(Q,1);
    for k=selected_FL_index.'
        gradient_aggregated=gradient_aggregated+N_f(k)/(sum(N_f(selected_FL_index,1)))*gradient_FL(:,k);
    end
    
    gradient_combine=sum(N_f(selected_FL_index,1))/(sum(N_f(selected_FL_index,1))+sum(N_c(selected_CL_index,1)))*gradient_aggregated+sum(N_c(selected_CL_index,1))/(sum(N_f(selected_FL_index,1))+sum(N_c(selected_CL_index,1)))*gradient_CL;
    
    global_net_old_vector=vec(global_net.IW{1,1});
    for i=1:1:(size(global_net.b,1)-1)
        global_net_old_vector=[global_net_old_vector;vec(global_net.LW{i+1,i})];
    end
    for i=1:1:size(global_net.b,1)
        global_net_old_vector=[global_net_old_vector;vec(global_net.b{i,1})];
    end

    global_net_new_vector=global_net_old_vector-eta*gradient_combine;
    start_point=0;
    global_net.IW{1,1}=reshape(global_net_new_vector(start_point+1:start_point+size(vec(global_net.IW{1,1}),1)),size(global_net.IW{1,1}));
    start_point=start_point+size(vec(global_net.IW{1,1}),1);
    for i=1:1:(size(global_net.b,1)-1)
        global_net.LW{i+1,i}=reshape(global_net_new_vector(start_point+1:start_point+size(vec(global_net.LW{i+1,i}),1)),size(global_net.LW{i+1,i}));
        start_point=start_point+size(vec(global_net.LW{i+1,i}),1);
    end
    for i=1:1:size(global_net.b,1)
        global_net.b{i}=reshape(global_net_new_vector(start_point+1:start_point+size(vec(global_net.b{i}),1)),size(global_net.b{i}));
        start_point=start_point+size(vec(global_net.b{i}),1);
    end

    predict_label=global_net(test_data.');
    predict_label=vec2ind(predict_label);
    predict_label=predict_label.';
    accuracy(rd,st)=1-(size(test_label,1)-sum(predict_label==test_label))/size(test_label,1);
    
    train_pre_label=global_net(train_data_all.');
    train_pre_label=train_pre_label.';
    loss(rd,st)=0;
    for i=1:1:size(train_data_all,1)
        loss(rd,st)=loss(rd,st)+log(train_pre_label(i,find(train_label_all(i,:)==1)));
    end
    loss(rd,st)=-1*loss(rd,st)/size(train_data_all,1);

    if isnan(loss(rd,st))
        break;
    end
    
    figure(1)
    plot(accuracy(1:rd,st),'k');

    figure(2)
    plot(loss(1:rd,st),'k');
    
end

save([save_address,'.mat'],'accuracy','loss');

end