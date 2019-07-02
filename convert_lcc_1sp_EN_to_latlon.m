%% convert_lcc_1sp_EN_to_latlon.m
% PL 01.06.2017
% Script to convert co-ordinates specified in easting, northing to latitude,
% longitude.
% This works with co-ordinates in LCC (Lambert conformal conic) projections
% with one standard parallel. 
% 
% Reverse procedure is in the function convert_lcc_1sp_latlon_to_EN.m
%% 
%
% See: EPSG Guidance Note Number 7. European Petroleum Survey Group. 
% POSC literature pertaining to Coordinate Conversions and Transformations including Formulas, p. 17-18.
%
%%


%% specify co-ordinate values to be converted:
% E=255966.58; % m (test values for Jamaica)
% N=142493.51; % m (test values for Jamaica)

% E=-161642; % MERA x-values run from approx.  -1481 to -161.64166 km
% N=682673; % MERA y-values run from approx. -537.3261 to 682.6739 km
E=-845524;
N=188600;


%% select projection to use
p=projection('mera');

%% conversion of angles from degrees to rad
d2r=pi./180;
p.phi_0=p.phi_0.*d2r;
p.lambda_0=p.lambda_0.*d2r;
p.lambda_f=p.lambda_f.*d2r;


%% calculated  projection values - some of these are redundant in the 1sp case
% (see EPSG document section 14.1.2 and 1.4.1.1)
p.f=(p.a-p.b)./p.a;                 % flattening [VERIFIED]
p.e=sqrt(2*p.f-p.f^2);            % eccentricity [VERIFIED]
p.eprime=sqrt(p.e^2./(1-p.e^2));   % second eccentricity 

%% iteration required for reverse conversion (EN to latlon):
% first set up the initial guess

%% n,m0,F,ro:
n=sin(p.phi_0); % [VERIFIED]
m0=cos(p.phi_0)./sqrt(1-(p.e^2).*(sin(p.phi_0)).^2); % [VERIFIED]
t0=(tan(pi./4 - p.phi_0./2))./( (1-p.e.*sin(p.phi_0))./(1+p.e.*sin(p.phi_0))).^(p.e./2);
F=m0./(n*(t0.^n)); % [VERIFIED]
r0=p.a.*F*(t0.^n); % [verified]

rprime=sign(n).*sqrt( (E-p.FE).^2 + (r0-(N-p.FN)).^2) ; % [VERIFIED]
tprime=(rprime./(p.a.*p.k0.*F)).^(1./n); % [VERIFIED]


thetaprime=atan( (E-p.FE)./(r0-(N-p.FN)) ); % [VERIFIED]
phi_trial=pi./2 - 2.*atan(tprime); % initial guess of phi


tol=0.0001; % convergence tolerance, degrees
%% iterate until phi  has  converged. 
num_it=0; err=Inf; % intialisation of convergence variables
phi=phi_trial;
t=tprime;
while (abs(err)>tol)
    phinew=pi./2 - 2.*atan( t.*( (1-p.e.*sin(phi))./(1+p.e.*sin(phi)) ).^(p.e./2) );
    err=phinew-phi;
    phi=phinew; % update phi for next iteration
    disp(['Iteration # ',num2str(num_it),' ; err = ',num2str(err)]);
    num_it=num_it+1;
end

%% lat , lon formulae as per 2SP case (EPSG document p. 17):
%% final version of t
t=(tan(pi./4 - phi./2))./( (1-p.e.*sin(phi))./(1+p.e.*sin(phi))).^(p.e./2);
lambda=thetaprime./n  + p.lambda_f;


%% finish
disp('----');
disp(['phi = ',num2str(phi)]);
disp(['lambda =',num2str(lambda)]);
disp(['Degrees: ',num2str(phi./d2r),' ,',num2str(lambda./d2r)]);
    
    