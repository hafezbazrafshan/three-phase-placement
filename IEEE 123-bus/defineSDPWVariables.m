variable Wnn3Phi(3,3, NBuses3Phi,M) hermitian semidefinite
variable Wnm3Phi(3,3,NBranches3Phi,M) complex


variable Wnn2Phi(2,2, NBuses2Phi,M) hermitian semidefinite
variable Wnm2Phi(2,2,NBranches2Phi,M) complex


variable Wnn1Phi(1,1, NBuses1Phi,M) hermitian semidefinite
variable Wnm1Phi(1,1,NBranches1Phi,M) complex

% create a placeholder 
expression W3Phi(6,6,NBranches3Phi,M);
expression W2Phi(4,4,NBranches2Phi,M);
expression W1Phi(2,2,NBranches2Phi,M);


