function [g2, taus] = g2sim(params, taus, tmin, tmax, method)

% ----- parse inputs -----
if ~exist('tmin', 'var') || isempty(tmin)
    tmin = 0;
end
if ~exist('tmax', 'var') || isempty(tmax)
    tmax = 5e-9;
end
if ~exist('taus', 'var') || isempty(taus)
    taus = [0 logspace(-7, 0, 100)];
end

muA = params.muA; %absorption coeff (1/mm)
muSp = params.muSp; %scatterring coeff (1/mm)
rho = params.rho; %source-detector separation (mm)
Db = params.Db; %Brownian diffusion coeff (i.e. BFi) (Note: doesn't affect beta)
if isfield(params, 'n')
    n = params.n; %index of refraction
else
    n = 1.33; %defaults to water
end
v = 3e11 / n; %speed of light in medium (mm/sec)
if isfield(params, 'pulseWidth')
    tCoh = params.pulseWidth; %(sec) assuming transform limited, [coherence time]=[pulse width]
    lCoh = v*tCoh; %coherence length (mm)
elseif isfield(params, 'lCoh')
    lCoh = params.lCoh;
end
lambda = params.lambda; %laser wavelength (mm)
ko = 2*pi*n/lambda;


% ----- TPSF integrand -----
TPSF = @(t) TPSFsim(t, muA, muSp, rho, n);
TPSFnorm = integral(TPSF,tmin,tmax);

% ----- g2 integrand -----
P = @(t) TPSF(t) / TPSFnorm; %pathlength distribution
g1 = @(t, tau) exp( - v*t*muSp * ko^2 * 2*Db*tau );
if ~exist('method', 'var') || strcmpi(method, 'bellini') 
    % Bellini Eq.7    
    g2integrandTau = @(t1, t2, tau) ...
        P(t1) .* P(t2) .* g1(t1, tau) .* g1(t2, tau) .* exp( -2*(v*(t1-t2)/lCoh).^2 );

elseif strcmpi(method, 'modified')
    if ~exist('T', 'var')
        error('Must specify gate shape for modified Bellini equation')
    end

%     g2integrandTau = @(t1, t2, tau) ...
%         P(t1).*T(t1) .* P(t2).*T(t2) .* g1(t1, tau) .* g1(t2, tau) .* exp( -2*(v*(t1-t2)/lCoh).^2 );

    
% Idea: normalize *gated* P to a pdf
%     P = @(t) P(t) .* T(t);
%     normP = integral(P, tmin, tmax);
%     gatedP = @(t) P(t) / normP;
%     g2integrandTau = @(t1, t2, tau) ...
%         gatedP(t1) .* gatedP(t2) .* g1(t1, tau) .* g1(t2, tau) .* exp( -2*(v*(t1-t2)/lCoh).^2 );
    
% Idea: use conv(P, irf) instead of P



    

else
    error('Invalid method')
end


% ----- Calculate g2 for every tau -----
g2 = nan(size(taus));
for i = 1:length(taus)
    tau = taus(i);
    g2integrand = @(t1, t2) g2integrandTau(t1, t2, tau);
    g2(i) = 1 + integral2(g2integrand,tmin,tmax,tmin,tmax); 
end


