function [Elam,tau,w_eq] = scanning_SEA2(s,vid,Ref1,bg,nop,range,dl,axis_num,home1,lam0,pks)
%% options 
% start with the stage at 0 delay
% nop is the number of delay points 
% scanning range is range
% s = serial object
% Ref1 = reference pulses interferogram
% dl = wavelength resolution (nm)
% vid = video object
% bg = background
% home1 = center of translation
% range = range of translation (mm)
% axis_num =  axis number


%% the actual code starts here
savefile = 'mud_trace_file.mat';
k=0;
%loop 1 to find the edge of the beam

c=300;
% moving forward
initial_x=home1-range/2;
max_x = home1+range/2;

a = range/nop; %step size
display(['The starting position is ' num2str(initial_x)]);
display(['The home position is ' num2str(home1)]);
display(['The ending position is ' num2str(max_x)]);
%loop 2 to take the data
n = 1;
M=3000;
Elam=zeros(M,nop);
tic;
current_x = initial_x;
prev(vid);
while n<=nop;
    %hold_on(18); %18 for 20 points and 22mm
     %hold_on(1);
%     hold_on(.25); % for 400 points and range of 5 cm
%     hold_on(6); %range = 22 and 100 pts
    %hold_on(1.5);
    I1=(double(getsnapshot(vid))-0*bg);
    %I1=multi_frame(vid,2);
    %%
    % Finding the phase and the spectrum:
        b = fftc(I1-Ref1,[],2);  %fourier transforming the the interferogram. 
        d = round(abs(pks(2)-pks(1))/2);  
        cut = ifftc(b(:,pks(1)-d:pks(1)+d),[],2);  %and this is to cut out the interference term  
        Elam(:,n)=sqrt(sum(abs(cut),2).^2./sum(Ref1,2)).*exp(i*mean(unwrap(angle(cut(:,2:end-1))),2));
     if n==1000
         save(savefile,'Elam');
         clear Elam
         k=k+1000;
     end
         
        %%

        % going forwards:
    x(n) = initial_x +a*(n-1);
    x1(n)=find_position(s,1);
    move_to_position(s,initial_x+a*n,axis_num);
%     %going backwards:
%     x(n) = initial_x -a*(n-1);
%     move_to_position(s,initial_x-a*n,axis_num);
    % the time for each step is
    tau(n)=2*(n-1)*a*1e6/c;
%     if n==1
%         tau1(n)=0;
%     else
%         tau1(n)=2*(n-1)*abs(x1(n)-x1(n-1))*1e6/c;
%     end
    n = n+1;
end
x = x-mean(x);
%% going home and plotting the result
move_to_position(s,home1,axis_num);
lam=(-M/2:(M-1)/2)*dl+lam0;
w_eq=equally_spaced_w(lam);
scan_end;
scan_end;
tau=mean(abs(diff(tau)));
toc
end