function [bestPoint, bestValue, path, values, iterations] = steepestGradient( functionExpression, parameters, originPoint, lowerBorder, upperBorder, precession1, precession2, limitIterations )
%SOLVER Finds the minimum of a function using a gradient with the steepest descent
    quantityOfParameters = max(size(parameters));

    if ~isequal(quantityOfParameters, 2)
        error('Error: function must have only two parameters.')
    end

    for i = 1 : 2
        eval(sprintf('syms %s', parameters{i}));
        eval(sprintf('%s = %d;', parameters{i}, 0));
    end

    symbolicFunction    = @(vector) subs(functionExpression, parameters, vector);
    gradientExpression  = [diff(sym(functionExpression), parameters{1}); diff(sym(functionExpression), parameters{2})];
    gradient            = @(vector) double ( subs(gradientExpression, parameters, vector) );
    gradientLength      = @(vector) norm(gradient(vector));

    fprintf('function expression: %s\n', char(functionExpression));
    fprintf('gradient expression: %s\n', char(gradientExpression));

    currentPoint = originPoint;   

    path = zeros(quantityOfParameters, limitIterations);
    values = zeros(1, limitIterations);

    syms T

    for iterations = 1 : limitIterations       
        if(isOutside(currentPoint, [lowerBorder, upperBorder]))
            fprintf('***END, because outside');
            break;
        end
        
        path(:, iterations) = currentPoint;
        values(iterations) = symbolicFunction(currentPoint);       
        
        fprintf('iteration: %d. current point: %s\n', iterations, mat2str(currentPoint));

        gradientVector = gradient(currentPoint);
        fprintf('\tgradient at current point: %s\n', mat2str(gradientVector));

        gradientLengthValue = gradientLength(currentPoint);
        fprintf('\tlength of gradient at current point: %s\n', mat2str(gradientLengthValue));

        if gradientLengthValue < precession1
            fprintf('***END, because length of gradient less, that %d\n', precession1);
            break;
        end
        
        nextPoint = currentPoint - T * gradientVector;
        fprintf('\tnext point : %s\n', char(nextPoint));
        
        expression = symbolicFunction(nextPoint);
        fprintf('\texpression of function at next point: %s\n', char(expression));

        firstDerivative = diff(sym(expression));
        fprintf('\tfirst derivative: %s\n', char(firstDerivative));

        step = double( solve(firstDerivative) );    
        fprintf('\tsulution of equation "first derivate = 0" : %d\n', step);

        secondDerivative = diff(sym(expression), 2);
        fprintf('\tsecond derivative: %s\n', char(secondDerivative));

        criterion = double( subs(secondDerivative, currentPoint) );
        fprintf('\tvalue of second derivative at current point: %d\n', criterion);

        step = min(step);
        next = currentPoint - gradientVector * step;   
        if criterion > 0                         
            deltaY = abs(symbolicFunction(next) - symbolicFunction(currentPoint));
            deltaX = sqrt((sum(next - currentPoint))^2);
            if (deltaX < precession2) && (deltaY < precession2) 
                fprintf('***END, because performed condition dx(%d) < %d && dy(%d) < %d\n', deltaX, precession2, deltaY, precession2);
                break;
            end            
            fprintf('\tmake step\n');
            currentPoint = next;
        end        
    end
    clear T
    
    [bestValue, index] = min(values);
    bestPoint = path(:, index);
    
    fprintf('\n\n\tIterations: %s. Best point: %s. \n\tBest value: %s\n',...
             iterations, mat2str(bestPoint), num2str(bestValue));
end
    
function [ result ] = isOutside( point, bounds )
    result = false;
    for k = 1 : 2
        if     point(k) < bounds(k, 1), result = true;
        elseif point(k) > bounds(k, 2), result = true; end;
    end;
end
