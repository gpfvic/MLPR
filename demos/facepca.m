load faces;
%Look at a sample of the dataset
%faces contains the different faces.
%facevec contains the vector form of the face
%obtained by
%facevec(:,ii)=face{ii}(:).
echo off
close all;
disp('A few example faces');
for ii=1:11:200
 imagesc(face{ii}(:,:,[1 1 1]));
 pause;
end
disp('Show the size of the face data')
%Run through each step of PCA one at a time:
echo on;
size(facevec)
pause;
%Calculate the mean face
meanfacevec=mean(facevec,2);
pause;
%Calculate the covariance between different pixels.
%covfacevec=cov(facevec');
pause;
%Calculate the eigenvalues and eigenvectors of the covariance.
%[vv,ee]=eig(covfacevec);
pause;
%Sort the eigenvalues into descending order
%[dummy,s]=sort(-diag(ee));
pause;
%Reorder the eigenvalues and eigenvectors into order of descending eigenvalue.
%vv=vv(:,s);ee=ee(s,s);
%Extract evals from the diagonal of ee
%ee=diag(ee);
pause;
echo off
load facesevec;
figure(1)

disp('Visualise the dominant eigenvectors.');
for ii=1:10
 pca{ii}=reshape(vv(:,ii),size(face{ii}));
 imagesc(pca{ii}(:,:));
 colormap(gray);
 pause;
end

disp('Run through a few faces');
for faceno=1:22:68
%figure
subplot(2,2,1)
%Plot the face
image(face{faceno}(:,:,[1 1 1]));

%The mean vector
subplot(2,2,3)
imagesc(reshape(meanfacevec,size(face{1})));
colormap(gray);

%A different face
subplot(2,2,2)
image(face{faceno+120}(:,:,[1 1 1]));

%The mean vector again
subplot(2,2,4)
imagesc(reshape(meanfacevec,size(face{1})));
colormap(gray);


disp('Now add components 5 at a time to build up the two faces.'); 
disp('To do this we calculate the component of that face in the direction of each principal component.')
%
pause;
for ii=1:30
  subplot(2,2,3)
  aaa=reshape(meanfacevec+vv(:,1:ii*5)*(vv(:,1:ii*5)'*(face{faceno}(:)-meanfacevec)),size(face{1}));
  imagesc(aaa);
  colormap(gray);
  subplot(2,2,4)
  aaa=reshape(meanfacevec+vv(:,1:ii*5)*(vv(:,1:ii*5)'*(face{faceno+120}(:)-meanfacevec)),size(face{1}));
  imagesc(aaa);
  colormap(gray);
  pause
end



end;

disp('Plot the proportion of explained variation.')
eec=cumsum(ee./sum(ee));
clf
plot(eec);
xlabel('Number of Components');
ylabel('Proportion of explained Variation');
pause

plot(eec(1:250));
xlabel('Number of Components');
ylabel('Proportion of explained Variation');
pause
