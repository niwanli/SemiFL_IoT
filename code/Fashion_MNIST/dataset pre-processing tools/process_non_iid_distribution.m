load('train_data_all.mat');
load('train_label_all.mat');

sample_total=60000;

K=10;
sample_per_device=6000;

number_of_class=10;
% sample_per_class=sample_per_device/number_of_class;

% total training dataset: 60000*784*10
total_sample=cell(number_of_class,1);
total_label=cell(number_of_class,1);
for i=1:1:number_of_class
    total_sample{i,1}=zeros(sum(train_label_all(:,i)),784);
    total_label{i,1}=zeros(sum(train_label_all(:,i)),10);
end

% divide dataset
for i=1:1:number_of_class
    index=zeros(sum(train_label_all(:,i)),1);
    point=1;
    for j=1:1:sample_total
        % category of each sample
        if(find(train_label_all(j,:)==1)==i)
            index(point,1)=j;
            point=point+1;
        end
    end
    temp_sample=train_data_all(index,:);
    temp_label=train_label_all(index,:);
    total_sample{i,1}=temp_sample;
    total_label{i,1}=temp_label;
end

% non-IID dataset: 7000*784*10
% each device has has one category of data
samples=cell(K,1);
% samples=zeros(sample_per_device,784,K);
labels=cell(K,1);
% labels=zeros(sample_per_device,10,K);
for k=1:1:K
    start_point=0;
%     random assignment?
%     index=randperm(10);
    for j=k
        temp_sample=total_sample{j,1};
        temp_label=total_label{j,1};
        samples{k,1}(start_point+1:start_point+size(temp_sample,1),:)=temp_sample;
        labels{k,1}(start_point+1:start_point+size(temp_label,1),:)=temp_label;
        start_point=start_point+size(temp_sample,1);
    end
end
train_data=samples;
train_label=labels;

save('non_iid_samples.mat','train_data');
save('non_iid_labels.mat','train_label');