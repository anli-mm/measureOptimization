
clear all;close all;clc;  
%% �������ó�ʼ��  
CNT = 1000;%����ÿ��(K,M,N)���ظ���������  
N = 256;%�ź�x�ĳ���  
Psi = eye(N);%x������ϡ��ģ�����ϡ�����Ϊ��λ��x=Psi*theta  
K_set = [4,12,20,28,36];%�ź�x��ϡ��ȼ��� 
%  K_set = [4,12,20] 
 start=25
     Percentage = zeros(length(K_set),N);%�洢�ָ��ɹ�����  
%% ��ѭ��������ÿ��(K,M,N)  
tic  
for kk = 1:length(K_set)  
    K = K_set(kk);%����ϡ���  
%     M_set = K:5:N;%Mû��Ҫȫ��������ÿ��5����һ���Ϳ�����  
 M_set = start:5:N;%Mû��Ҫȫ��������ÿ��5����һ���Ϳ�����  :5:N;%Mû��Ҫȫ��������ÿ��5����һ���Ϳ�����  
    PercentageK = zeros(1,length(M_set));%�洢��ϡ���K�²�ͬM�Ļָ��ɹ�����  
    for mm = 1:length(M_set)  
       M = M_set(mm);%���ι۲�ֵ����  
       P = 0;  
       for cnt = 1:CNT %ÿ���۲�ֵ����������CNT��  
            Index_K = randperm(N);  
            x = zeros(N,1);  
            x(Index_K(1:K)) = 5*randn(K,1);%xΪKϡ��ģ���λ���������                  
%             Phi = randn(M,N);%��������Ϊ��˹����  
           Phi=BernoulliMtx(M,N);%��Ŭ����������
%            Phi=ToeplitzMtx(M,N);%�����Ȳ�������
%                d=ceil(M/2);
%            Phi=SparseRandomMtx(M,N,d);
%               [Phi]=QRMeasurefunction(Phi);
              [Phi]=SVDmeasurefunction(Phi);
%             [Q,R]=qr(Phi');
%             [a,b]=size(R);
%             for i=1:a
%                 for j=i:b
%                     if i~=j
%                         R(i,j)=0;
%                     end
%                 end
%             end
%             ymax=max(max(R));
%              for i=1:a
%                 for j=i:b
%                     if i==j
%                         R(i,j)=ymax;
%                     end
%                 end
%             end
%             Phi=R'*Q';
% %             Phi=Phi';
            A = Phi * Psi;%���о���  
            y = Phi * x;%�õ��۲�����y  
%             theta = cs_omp(y,A,K);%�ָ��ع��ź�theta  
%              theta = CS_ROMP(y,A,K);
%              theta = CS_ROMP(y,A,K);
                theta=CS_gOMP(y,A,K);
%               theta = CS_CoSaMP(y,A,K);
            x_r = Psi * theta;% x=Psi * theta  
            if norm(x_r-x)<1e-6%����в�С��1e-6����Ϊ�ָ��ɹ�  
                P = P + 1;  
            end  
       end  
       PercentageK(mm) = P/CNT*100;%����ָ�����  
    end  
    Percentage(kk,1:length(M_set)) = PercentageK;  
end  
toc  
% save MtoPercentage1000CS_gOMP_TPMx_raQR %����һ�β����ף��ѱ���ȫ���洢����  
save MtoPercentage1000CS_gOMP_TPMx_raSVD %����һ�β����ף��ѱ���ȫ���洢���� 
%% ��ͼ  
S = ['-ks';'-ko';'-kd';'-kv';'-k*'];  
% figure;  
for kk = 1:length(K_set)  
    K = K_set(kk);  
    M_set = K:5:N;  
    L_Mset = length(M_set);  
    plot(M_set,Percentage(kk,1:L_Mset),S(kk,:),'MarkerFaceColor','red','color',[1 0 0]);%���x�Ļָ��ź�  
    hold on;  
end  
hold off;  
xlim([0 256]);  
legend('K=4','K=12','K=20','K=28','K=36');  
xlabel('Number of measurements(M)');  
ylabel('Percentage recovered');  
title('Percentage of input signals recovered correctly(N=256)(Gaussian)');