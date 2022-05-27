function [ h ] = get_channels( K,N_r,location,seed )
%获取完美CSI条件下的各个信道矩阵
%   注意，各个信道矩阵已经方差归一化

%信道参数,主要参考论文Resource Allocation for Multi-Cell IRS-Aided NOMA Networks
%w,与基站单位距离处的路损
C_0=10^(-30/10);
%device-BS路损因子
tau=2.2;
%device-BS莱斯因子
kappa=2;

rng(seed)
%small scale fading
h_small=zeros(N_r,K);
for k=1:1:K
    re_h_samll=random('Normal',0,sqrt(1/2),N_r,1);
    im_h_small=random('Normal',0,sqrt(1/2),N_r,1);
    h_small_rayleigh=re_h_samll+1i*im_h_small;%h_k的瑞利部分分量
    h_small(:,k)=sqrt(kappa/(kappa+1))*ones(N_r,1)+sqrt(1/(kappa+1))*h_small_rayleigh;
end
rng('shuffle');

%large scale fading
location_BS=zeros(K,3);
location_BS(:,3)=10*ones(K,1);
distance=sqrt(sum((location-location_BS).^2,2));
h_large=C_0*distance.^(-tau);

%get channels
h=zeros(N_r,K);
for k=1:1:K
    h(:,k)=sqrt(h_large(k))*h_small(:,k);
end
h=h.';

end

