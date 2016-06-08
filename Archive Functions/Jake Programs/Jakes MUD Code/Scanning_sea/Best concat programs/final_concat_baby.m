% This function concatenates the data baby!!!

function [Et,E_lam,t_f,lam_eq,amp,t1]=final_concat_baby(Elam,dtau,dl,lam0)
% making the spectrum equally spaced:
N=size(Elam,1);
lam=(-N/2:(N-1)/2)*dl+lam0;
Ew=zeros(size(Elam));
[seq1,w]=equally_spaced_spectrum_w(lam,abs(Elam));
[phase1,w]=equally_spaced_spectrum_w(lam,unwrap(angle(Elam)));
Ew=seq1.*exp(i*phase1);

% filtering in the delay dimension:
d1=4;
d2=1;
Ew=Ew(:,[d1:end-d2]);
% fourier filtering:
x_c1=400;
x_c2=2500;
x2=1;
ymax=15;
% plotting the traces:
% the retreived spectrogram:
[Ew1,w1]=sub_bg2(Ew,x_c1,x_c2,w,x2,ymax);
% subtracting the ref phse:
if nargin==5
    frog_data=varargin{1};
    [Ew1]=phase_tadpole(frog_data,w1,Ew1);
end
% concatenating the results:
[Et,E_lam,t_f,lam_eq,amp,t1]=best_concat2_mud_v2(fliplr(Ew1),dtau,w1,lam0);
% plot_single_mud;