function [ location ] = get_locations( K,radius_min,radius_max,seed )
%�����û��豸����վ���꣬��վ���������
%�û��豸����վλ��,�ݶ�3d����,(0,0,0)Ϊ���ġ��뾶ά100m��Բ��Χ��

%�������Ӳ���λ��
rng(seed);
r=radius_min+(radius_max-radius_min)*rand(K,1);%�����Ͼ��ȷֲ�
angle=2*pi*rand(K,1);%�Ƕ��Ͼ��ȷֲ�
location=zeros(K,3);
location(:,1)=r.*cos(angle);
location(:,2)=r.*sin(angle);
rng('shuffle');

end