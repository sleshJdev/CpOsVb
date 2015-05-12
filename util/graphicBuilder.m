function [ xM, yM, zM ] = graphicBuilder(symbolicaFunction, parameters, initial, lowerBorder, upperBorder )     
    quantity = max(size(parameters));
    
    % define symbolic variable  
    for i = 1 : quantity                 
        eval(sprintf('syms %s', parameters{i}));
        eval(sprintf('%s = %d;', parameters{i}, initial(i))); 
    end   
   
    targetFunction1 = @(x) double( subs(symbolicaFunction, parameters, x) );
    targetFunction2 = @(x, y) double( subs(symbolicaFunction, parameters, {x, y}) );    
%     disp(targetFunction(initial));
        
    quantitySteps = 100;
    maxRange = max(upperBorder);
    minRange = min(lowerBorder);
    stepSize = (maxRange - minRange) / quantitySteps;
    if isequal(quantity, 1)
        xM = minRange : stepSize : maxRange;
        yM = targetFunction1(xM);    
        zM = [];
    elseif isequal(quantity, 2)         
        [xM, yM] = meshgrid(minRange:stepSize:maxRange, minRange:stepSize:maxRange);
        zM       = targetFunction2(xM, yM);         
    end
end

