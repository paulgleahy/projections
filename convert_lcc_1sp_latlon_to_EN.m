%% convert_lcc_1sp_latlon_to_EN.m
% PL convert pair of coordinates from lat,long co-ordinates in Lambert Conformal Conic projection
% to grid co-ordinates (Easting , Northing)
% 1 standard parallel version (e.g. Jamaica JAD, Met Eireann MERA data)
% 01.06.2017
%% 
% MERA uses Lambert conformal conic projection, with one standard parallel.
%
% See: EPSG Guidance Note Number 7. European Petroleum Survey Group. 
% POSC literature pertaining to Coordinate Conversions and Transformations including Formulas, p. 17-18.
%
d2r=pi./180; 


%% select the projection to use

p=projection('mera');

%% calculated  projection values - many of these are redundant in the 1sp case
% (see document section 14.1.2 and 1.4.1.1)
p.f=(p.a-p.b)./p.a;                 % flattening [VERIFIED]
p.e=sqrt(2*p.f-p.f^2);            % eccentricity [VERIFIED]
p.eprime=sqrt(p.e^2./(1-p.e^2));   % second eccentricity 


%% sample input values to convert 
% phi, lamba. (lat,long)

%% test location for Jamaica JAD (from EPSG Jamaica
%JAD example, p.19): 
%phi=0.31297535; % [rad] 
%lambda=-1.34292061; % [rad]

%% test location : SW edge of MERA grid
%phi=d2r.*46.834; 
%lambda=d2r.*(-14.609); 

%% test location: ballyshannon
phi=d2r.*54.4920;
lambda=d2r.*(-8.172);

%% convert angles from degrees to rads

phi_0=p.phi_0.*d2r;
lambda_0=p.lambda_0.*d2r;
%lambda_f=p.lambda_f.*d2r;


m0=cos(phi_0)./sqrt(1-(p.e^2).*(sin(phi_0)).^2);

t0=(tan(pi./4 - phi_0./2))./( (1-p.e.*sin(phi_0))./(1+p.e.*sin(phi_0))).^(p.e./2);
t=(tan(pi./4 - phi./2))./( (1-p.e.*sin(phi))./(1+p.e.*sin(phi))).^(p.e./2);
%tf=(tan(pi./4 - phi_f./2))./( (1-p.e.*sin(phi_f))./(1+p.e.*sin(phi_f))).^(p.e./2);

n=sin(phi_0); % [VERIFIED]
F=m0./(n*(t0.^n)); % [VERIFIED]


% calculate r
r=p.a.*F.*(t.^n); % [VERIFIED]
r0=p.a.*F*(t0.^n); 


%% calculate easting and northing :

theta=n.*(lambda-lambda_0);

E=p.FE + r.*sin(theta); % 
N=p.FN + r0 - r.*cos(theta);%
disp('Easting, Northing: ');
disp(num2str([E N]./1000));
