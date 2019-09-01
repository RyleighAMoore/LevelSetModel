X = test(:,1); Y = test(:,2); Z = test(:,3);
Xs = unique(X);
Ys = unique(Y);
Xi = arrayfun( @(x) find(Xs==x), X );
Yi = arrayfun( @(y) find(Ys==y), Y );
Li = Yi + (Xi-1) * numel(Ys);
XYZ = nan(numel(Ys), numel(Xs));
XYZ( Li ) = Z;