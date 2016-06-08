
function [U1,H1,g1]=add_phase_delay2(Ut,tw,H2,x1,U_begin,U_end,H_begin,H_end)
%H2=ones(size(Ut));
H_begin=H_begin';
H_end=H_end';
H=abs(H2);   
N=size(Ut,2)+2;
z0=0;
x=round(tw)-z0;
Ut1=Ut;
x2=x1-(x1-tw)/2;
% the length of the beginning and end is:
N_begin_end=length(U_begin);
b=zeros(N_begin_end,1);
for k=1:N
        if k==1
            a1(1:(N-k)*(x))=0;
            U(:,k)=cat(1,U_begin,a1');
            % adding on the end zeroes
            U1(:,k)=cat(1,U(:,k),b);
            %phase1(:,k)=cat(1,a1',phase0(:,k));
            g1(k)=x2;
            if ischar(H)==0
                H1(:,k)=cat(1,H_begin,a1');
                H3(:,k)=cat(1,H1(:,k),b);
            end
            clear a1 U H1;
        elseif k==N
            a2(1:x*(N-1))=0;
            U(:,k)=cat(1,a2',U_end);
            % adding on the beginning zeros:
            U1(:,k)=cat(1,b,U(:,k));
            %phase1(:,k)=cat(1,phase0(:,k),a2');
            g1(k)=tw+(x1-tw)/2+g1(k-1);
            if ischar(H)==0
                H1(:,k)=cat(1,a2',H_end);
                H3(:,k)=cat(1,H1(:,k),b);
            end
            clear a2 U H1;
        else
            a3(1:x*(k-1))=0;
            a4(1:(N-k)*x)=0;
            U(:,k)=cat(1,cat(1,a3',Ut1(:,k)),a4');
            % adding on the beginning zeros:
            U2(:,k)=cat(1,b,U(:,k));
            % adding on the end zeroes
            U1(:,k)=cat(1,U2(:,k),b);
          
            %phase1(:,k)=cat(1,cat(1,a4',phase0(:,k)),a3');
            g1(k)=tw+(x1-tw)/2+g1(k-1);
            if ischar(H)==0
                H1(:,k)=cat(1,cat(1,a3',H(:,k)),a4');
                H4(:,k)=cat(1,H1(:,k),b);
                H3(:,k)=cat(1,b,H4(:,k));
            end
            clear a4 a3 U;
        end
end 
g1=round(g1);