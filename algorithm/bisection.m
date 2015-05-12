function [ x, y, xMin, yMin ] = bisection(xLeft, xRight, stepSize, targetFunction)
    xMin   = (xLeft + xRight) / 2;
    yMin   = targetFunction(xMin);
    
    numberOfSteps = (xRight - xLeft) / stepSize;
    
    %create vector x and y
    y = zeros(1, numberOfSteps);
    x = zeros(1, numberOfSteps);
    sizeOfStep = (xRight - xLeft) / numberOfSteps;
     for index = 1 : numberOfSteps
        x(index) = xLeft + (index - 1) * sizeOfStep;
        y(index) = targetFunction(x(index));   
     end;
     
    %_________________________find minimal 'y'

    for index = 1 : numberOfSteps    
        xMidleLeft  = (xLeft + xMin) / 2;
        xMidleRight = (xMin + xRight) / 2;  
        yMidleLeft  = targetFunction(xMidleLeft);
        yMidleRight = targetFunction(xMidleRight);
        if (yMidleLeft < yMin )
            xMin   = xMidleLeft;
            yMin   = yMidleLeft;
            xRight = xMidleRight;
            yRight = yMidleRight;
        elseif (yMidleRight < yMin)
            xMin   = xMidleRight;
            yMin   = yMidleRight;
            xleft  = xMidleLeft;
            yLeft  = yMidleLeft;
        else
            xLeft  = xMidleLeft;
            yLeft  = yMidleLeft;
            xRight = xMidleRight;
            yRight = yMidleRight;
            xMin   = (xLeft + xRight) / 2;
            yMin   = targetFunction(xMin);
        end;        
    end;
end

