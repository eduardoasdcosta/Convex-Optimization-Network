clear;
close all;

%parameters of the network
nLinks = 100;
nFlows = 30;
minC = 50;
maxC = 200;
nIter = 25;     %number of different values of latency to be optimized
mode = 1;       %0 = example, 1 = random, 2 = repeat last random try

if (mode == 0)
    load 'ExampleGraph.mat'
elseif(mode == 1)
    %generates a random routing matrix and a random capacities vector
    [R, c] = generateParams(nLinks, nFlows, minC, maxC);
elseif(mode == 2)
    load 'networkParams.mat'
end

%plots the network graph, if it isn't too cluttered
if(nLinks <= 25 && nFlows <= 3)
    plotGraphs(R, nLinks, nFlows);
end

%maximum possible network utility function, ignoring latency
cvx_begin
variable f(nFlows)
maximize sum_log(f);
R*f <= c;
f >= 0; 
cvx_end
Umax = cvx_optval;

%minimum possible flow latency of the network, ignoring utility
Lmin = max(R'*(1./c));

%now we try to find several values that optimize our problem, for different values of latency
LStep = 1.1*Lmin*logspace(0, 1, nIter); %get a logarithmically spaced vector, from 1.1*Lmin to 11*Lmin
Opt = [];
for i = 1:nIter
    cvx_begin
    variable f(nFlows)
    maximize sum_log(f);
    R'*inv_pos(c-R*f) <= LStep(i)*ones(nFlows,1);
    R*f <= c;
    f >= 0;
    cvx_end
    Opt = [Opt cvx_optval];
end

%plot our line of optimal values
figure(1)
semilogx(LStep, Opt, 'k')
hold on
semilogx([1 1]*Lmin, ylim, '--k')
semilogx(xlim, [1 1]*Umax, '--k')
x = xlim;
xlim([x(1) - (x(2) - x(1))/100 x(2)])
xlabel('Latency'); ylabel('Utility function')
title({'Network with ' + num2str(nLinks) + ' links and ' + num2str(nFlows) + ' flows'})
hold off