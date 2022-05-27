function [ location ] = get_locations( K,radius_min,radius_max,seed )
%产生用户设备、基站坐标，基站坐标在最后
%用户设备、基站位置,暂定3d坐标,(0,0,0)为中心、半径维100m的圆范围内

%传入种子产生位置
rng(seed);
r=radius_min+(radius_max-radius_min)*rand(K,1);%径向上均匀分布
angle=2*pi*rand(K,1);%角度上均匀分布
location=zeros(K,3);
location(:,1)=r.*cos(angle);
location(:,2)=r.*sin(angle);
rng('shuffle');

end