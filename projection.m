% projection.m
%% Sets up  LCC projection constants for different projections.
% For use with lambert conformal conic projection conversion functions,
% convert_lcc_1sp_EN_to_latlon(), 
% 
% PL 02.06.2017
%
% INPUTS
% proj_name     string  One of 'MERA','JAD69','NAD27-Tex-4'
%
% OUTPUTS
% p             struct
% Structure containing the fields:
% 
% r0            earth radius (m)
% a,b           ellipsoid semi-major and semi-minor radii (m)
% phi_0         [1sp case] latitude of natural origin (degrees)
% lambda_0      longitude of natural origin
% k0            scale factor at origin
% FE            false easting (m), at natural origin
% FN            false northing (m), at natural origin
% The above fields are required for reverse conversion (grid E,N ->lat,lon):
%
% 
% For the 2 std parallel case (e.g. Texas), phi_1 and phi_2 are returned instead of
% phi_0
% 
% For forward conversion (latlon->grid), the following parameters are required: 
% EF, EN instead of FE, FN. 
% 
%%
% See: EPSG Guidance Note Number 7. European Petroleum Survey Group.
% POSC literature pertaining to Coordinate Conversions and Transformations including Formulas, p. 17-18.
%
% NB Check that the projection structure contains all the values you need to
% carry out your conversion before proceeding, and edit the code if
% necessary! 
%%

function p=projection(proj_name)

switch lower(proj_name)
    case 'mera'
        % Set up MERA Met Eireann reanalysis projection constants
        pmera.r0=6367470; % value used by MERA for earth radius
        pmera.a=pmera.r0; pmera.b=pmera.r0;  % ellipsoid semi-major and semi-minor axes. I think MERA uses a sphere.

        pmera.phi_0=53.5   ; % latitude of natural origin
        pmera.lambda_0=5.0; % longitude of natural origin 5 deg W
        pmera.k0=1.0;          % scale factor at origin (1SP)
        pmera.FE=0 ; % meters; this is the false easting of the MERA projection natural origin. it is probably zero (location of natural origin 15 E)
        pmera.FN=0; % also probably zero.

        pmera.lambda_f=5.0;  % longitude of false origin. 2 W or maybe 5W?

        p=pmera;
    case 'jad69'
        %% set up Jamaica JAD69 projection constants
        pjam.a=6378206.4;
        pjam.b=6356583.8;

        pjam.phi_0=18;
        pjam.lambda_0=-77; % W
        pjam.k0=1.0;
        pjam.FE=250000;
        pjam.FN=150000;
        %pjam.phi_1=pjam.phi_0; % check***
        %pjam.lambda_f=pjam.lambda_0; % check***
        p=pjam;
    case 'nad27-tex-4'
        %% set up Texas constants NAD27 (NAD27 Zone 4, TX SC-4204 SPC)
        ussf2m=1200/3937; % conversion factor US survey foot to meter
        % see: http://vterrain.org/Projections/sp_feet.html

        ptex.a=6378206.4;
        ptex.b=6356583.8;

        ptex.phi_f=27+(50./60);
        ptex.lambda_f=(-99.0);

        ptex.phi_1=(28+(23./60));
        ptex.phi_2=(30+(17./60));

        ptex.EF=ussf2m.*2000000;
        ptex.NF=0;

        p=ptex;
end
