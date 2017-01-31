function gate = make_gate_fn(gatemin, gatemax, irf, microRes)

irfTof = (0:length(irf)-1)*microRes;
irf = irf/trapz(irfTof, irf);

box = zeros(size(irf));
box(gatemin <= irfTof&irfTof <= gatemax) = 1;

gateVec = conv(box, irf*microRes); 
% multiply by microRes bc assumes irf(t) = \sum_T irf(T)*dT*delta(t-T)
% (so dT = microRes) i.e. a rectangular approximation of irf(t) like in 
% http://people.clarkson.edu/~jsvoboda/Syllabi/EE221/Laplace/convolution.pdf
% For more accuracy, TODO: trapezoidal approx

% %normalize peak to 1
% gateVec = gateVec/max(gateVec);


gateTof = (0:length(gateVec)-1)*microRes;

% plot(irfTof, box)
% hold on;
% plot(irfTof, irf)
% plot(gateTof, gateVec);

gate = @(t) interp1(gateTof, gateVec, t, 'spline', 0);






% --- Alt. idea for gate function: deconvolution
% irfTof = (0:length(irf)-1)*microRes;
% irf = irf/trapz(irfTof, irf);
% box = zeros(size(irf));
% box(gatemin <= irfTof&irfTof <= gatemax) = 1;
% 
% [gateVec, R] = deconv(box, irf*microRes);
