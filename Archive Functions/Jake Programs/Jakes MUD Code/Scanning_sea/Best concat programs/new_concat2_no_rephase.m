% this function performs the concatenation without shifting
% U1 = temporally filtered slices
% Ht = the weighting functions
% tau = delay between reference pulses (in index points not fs)
% x = temporal length of each section (in index points not fs)
% offset = is the phase offset for phase concatenation

function [Ef]=new_concat2_no_rephase(U1,H,tau,x,offset)
Q=size(U1,2);
% the length of the final concatenated field will be:
L = (Q-1)*tau+x;
% setting the intial arrays to zero:
E=zeros([L,1]);
amp1=E;
phase1=E;
Htot=E;

% Getting the phase info:
for k=1:Q
    phase2(:,k)=unwrap(angle(U1(:,k)));
end

for k=1:L
    % the starting segment value
    if k<x
        m0=1;
    else
        m0=ceil((k-x)/tau+1);
    end
    % the final segment value
    mf=ceil(k/tau);
    if mf>Q
        mf=Q;
    end
    
    for m=m0:mf
        z=k-tau*(m-1);
        amp1(k)=amp1(k)+abs(U1(z,m))*H(z,m);
        phase1(k)=phase1(k)+(phase2(z,m)-0*offset(m))*H(z,m);    
        Htot(k)=Htot(k)+H(z,m);
    end
end
phase_tot=phase1./Htot;
amp_tot=amp1./Htot;
Ef=amp_tot.*exp(i*phase_tot);
5;