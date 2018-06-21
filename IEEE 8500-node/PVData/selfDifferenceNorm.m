function [ nu ] = selfDifferenceNorm(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

N=length(x);
X1=repmat(x,1,N); 
X2=repmat(x.',N,1); 

nu=abs(X1-X2);
end

