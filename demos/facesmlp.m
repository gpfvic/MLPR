%function facesmlp

load attfacesdata

echo on
% Fix the seeds
rand('state', 423);
randn('state', 423);
pause;

% Now set up and train the MLP
nhidden=20;
ninputs=644;
nout=40;
ncycles=400;
pause;

% Convert targets to 0-1 encoding

%row of data= input vector
%row of target= target vector

target = sparse(1:length(trainfaceslabels),trainfaceslabels,ones(1,length(trainfaceslabels)));
target = full(target);
testtarget = sparse(1:length(testfaceslabels),testfaceslabels,ones(1,length(testfaceslabels)));
testtarget = full(testtarget);
data = trainfacesvec';
md=mean(data);
sd=std(data);
data=data-md(ones(1,size(data,1)),:);
data=data*diag(1./sd);
testdata=testfacesvec';
testdata=testdata-md(ones(1,size(testdata,1)),:);
testdata=testdata*diag(1./sd);
pause;


% Set up MLP network
net = mlp(ninputs, nhidden, nout, 'softmax');
pause;

options = zeros(1,18);
options(1) = 1;                 % Print out error values
options(14) = ncycles;
pause;


% Train using scaled conjugate gradient.
[scgnet] = netopt(net, options, data, target, 'scg');
y = mlpfwd(scgnet, data);
yp=mlpfwd(scgnet,testdata);

pause
imagesc(testtarget+2*yp)
colormap([0 0 0; 0 0 1; 0 1 0; 1 1 1])

pause;
options(18)=0.05;
[gradnet] = netopt(net, options, data, target, 'graddesc');
pause

options(18)=0.2;
[gradnet] = netopt(net, options, data, target, 'graddesc');
pause

pause;

% Now set up and train the MLP
nhidden=200; %Change
ninputs=644;
nout=40;
ncycles=400;
pause;

% Set up MLP network
net = mlp(ninputs, nhidden, nout, 'softmax');
pause;
[scgnet] = netopt(net, options, data, target, 'scg');
y = mlpfwd(scgnet, data);
yp=mlpfwd(scgnet,testdata);

pause
imagesc(testtarget+2*yp)
colormap([0 0 0; 0 0 1; 0 1 0; 1 1 1])

pause;


echo off

