function [newdata, attrmap] = datato1ofm( data );
%datato1ofm - recast data in 1 of M format, maintaining multinomial info.
%function [newdata, attrmap] = datato1ofm( data );
%
% DATA is the complete dataset. It is presumed that all the possible states
% are represented in the dataset. If not the data should be augmented with
% dummy data so that this is the case. Each column of DATA corresponds to 
% a different attribute, and each row a different data item. DATA must be
% numeric.
%
% NEWDATA is a sparse real-binary 1 of M dataset. All attributes are one 
% of M encoded, including previous binary attributes. The split of these 
% previously binary attributes can be removed trivially: see below.
%
% ATTRMAP gives the attribute mapping information. ATTRMAP(1,k) gives the
% original atribute number for the kth new attribute. ATTRMAP(2,k) gives 
% the value of the original attribute indicated by the kth new attribute.
% ATTRMAP(3,k) indicates how many elements the kth new attribute is one of.
%
% To remove 1 of M encoding for previously binary attributes use
%
% ii = find(~(attrmap(2,:)==1 & attrmap(3,:)==2)); 
% newdata = newdata(:,ii); attrmap = attrmap(:,ii);
%
% To compute multinomial probabilities (simply but inefficiently) use
%
% normmatrix = sparse([1:size(attrmap,2)],attrmap(1,:),1);
% normmatrix = normmatrix*normmatrix';
% probs = mean(newdata)./(mean(newdata)*normmatrix);
%
%Copyright 2010, Amos Storkey, University of Edinburgh. 

%Licensed under a WTFPL variant. Everyone is permitted to copy and 
%distribute verbatim or modified copies of this licensed document 
%in whatever form, and changing it is allowed as long as the 
%associated changes are not attributed to the current author.
%Obviously, this document comes with no warranty about 
%anything, ever, to the extent permitted by applicable law.
%

%This code is written with simplicity rather than efficiency in mind.

newdata=sparse([]);

numattr = size(data,2);
numitems = size(data,1);

newattr = 1;

for attr = 1:numattr
  contentlist = unique(data(:,attr));
  for m = contentlist'
    newdata(:,newattr) = double(data(:,attr)==m);
    attrmap(1,newattr)=attr;
    attrmap(2,newattr)=m;
    attrmap(3,newattr)=length(contentlist);
    newattr=newattr+1;
  end
end

  