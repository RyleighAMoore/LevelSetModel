function [X,Y] = UnfoldingPositive(E,n,Deg,nbins)
%   [X,Y] = UnfoldingPositive(E,n,Deg,nbins)
%
%   E:      matrix of size (nsamples x N)
%   n:      scalar (typical value 10 to 40)
%   Deg:    scalar (typical values 7 to 15)
%   nbins:  scalar (typical values 40 to 80)
%    
%
%
%   This code unfolds a positive sequence of 'N' eigenvalues for 'nsamples'
%   matrix samples through polynomial fitting of the cumulative 
%   distribution. 
%   The fitting polynomial has degree 'Deg'.
%   The code takes as input a matrix E of size (nsamples x N) where row j 
%   contains the N positive eigenvalues of the j-th sample, and a number 
%   'n' of points between 0 and Ymax=max(max(E)). 
%   The cumulative distribution is computed over the 'n' points in the 
%   vector YR as the fraction of eigenvalues lying below YR(j) and stored
%   in the vector CumDist.
%   Then a polynomial fitting is performed over the cumulative density
%   profile obtained in this way, and the resulting polynomial is then
%   computed on all the entries of E (---> xiMatr1).
%   The subfunction HistUnfold computes the nearest-neighbor difference
%   between the unfolded eigenvalues in xiMatr1 (row-by-row), and produces
%   a normalized histogram Y with 'nbins' (number of bins) centered at X,
%   ready to be plotted.
nsamples = size(E,1);
N = size(E,2);
Ymax = max(max(E));
YR = linspace(0,Ymax,n);
for j = 1:n
    CumDist(j) = length(find(reshape(E,1,N*nsamples) <= YR(j)))/nsamples;
end
p = polyfit(YR,CumDist,Deg);
FitDist = polyval(p,YR);
xiMatr1 = polyval(p,E);
[X,Y] = HistUnfold(xiMatr1',N,nsamples,nbins);
function [Xn,Yn] = HistUnfold(Mat,NN,ns,nbins)
d = diff(Mat);
d2 = reshape(d,1,(NN-1)*ns);
[Yn,Xn] = normhist(d2,nbins);
function [hnorm,ics] = normhist(vec, nbins)
[h,ics] = hist(vec,nbins);
xspan = diff(ics);
Atot = sum(xspan.*h(1:end-1));
hnorm = h/Atot;  