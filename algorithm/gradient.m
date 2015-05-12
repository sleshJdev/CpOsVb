function [ vMin, point, path ] = gradient(symbolicFunction, parameters, x1, x2, y1, y2, e, ox, oy, s, sl )
%GSFS Gradient Search Fixed Step Function
%   finds the minimum of the function
%   using the gradient method with constant step

startPoint              = [ox; oy];
% define symbolic variable
for i = 1 : max(size(parameters))
    eval(sprintf('syms %s', parameters{i}));
    eval(sprintf('%s = %d;', parameters{i}, startPoint(i)));
end

% symbol expression of fucntion
% must be same as 'f'
f = symbolicFunction;
% digital expression of function
f2v1 = @(p) double( subs(f,parameters,p) );
f2v2 = @(a,b) double( subs(f,parameters,{a,b}) );
% gradien in symbolic expression:
g = [diff(sym(f), parameters{1}); diff(sym(f), parameters{2})];
% gradien in digital expression(vector)
gd = @(p) double( subs(g, parameters, p) );
% length of gradient
f2gl = @(p) norm( gd(p) );
% normalized gradient
f2go = @(p) gd(p)/f2gl(p);

limit                   = sl;
precision               = e;
sizeOfStep              = s;

currentPoint            = startPoint;
path                    = startPoint;
bounds                  = [x1, x2;  % x definitional domain
                           y1, y2]; % y definitional domain
stopper = 1;
isRunning = true;
while isRunning
    stopper = stopper + 1;
    if stopper == limit
        break;
    end;
    grad         = f2go(currentPoint);
    nextPoint    = currentPoint - sizeOfStep*grad;
    range        = f2v1(nextPoint) - f2v1(currentPoint);
    currentPoint = nextPoint;

    if isOutAbroad(currentPoint, bounds)
        break;
    end
    
%     if  pdist([currentPoint(1), nextPoint(1); currentPoint(2), nextPoint(2)], 'euclidean') <= precision
%         break;
%     end;

    path = [path, currentPoint];
end;
point = currentPoint;
path = [path(1,:);path(2,:);f2v2(path(1,:),path(2,:))];
vMin = [point(1), point(2), f2v1(point)];
end

function [state] = isOutAbroad(point, bounds)
    state = false;
    if point(1) < bounds(1, 1) || point(1) > bounds(1, 2) ||...
       point(2) < bounds(2, 1) || point(2) > bounds(2, 2)
        state = true;
    end;
end





