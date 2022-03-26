function [AreaFraction] = FindAreaFraction(z,PlaneHeight)

NormalCount = sum(sum(real(z < PlaneHeight)));
[a,b]=size(z);
AreaFraction = NormalCount/(a*b);
end

