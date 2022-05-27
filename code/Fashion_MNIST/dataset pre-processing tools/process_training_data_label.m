h=load('train_label_all.mat');
num_data=60000;
categories=10;
train_label=zeros(num_data,categories);
for i=1:1:num_data
    train_label(i,h.train_label(i,1))=1;
end

save('train_label.mat',"train_label");