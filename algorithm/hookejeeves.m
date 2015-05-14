function [X,BestF,Iters, path, values] = hookejeeves(N, X, StepSize, MinStepSize, Eps_Fx, MaxIter, lower, upper, myFx)
    % source: http://www.namirshammas.com/MATLAB/Optim_HookeJeeves.htm

%     N - number of variables
%     X - array of initial guesses
%     StepSize - array of search step sizes
%     MinStepSize - array of minimum step sizes
%     fxToler - tolerance for function
%     MaxIter - maximum number of iterations
    
    Xnew = X;
    BestF = feval(myFx, Xnew);
    LastBestF = 100 * BestF + 100;

    bGoOn = true;
    Iters = 0;

    values = [];
    path = [];
       
    while bGoOn
        disp('Global loop');
        Iters = Iters + 1;
        if Iters > MaxIter
            break;
        end      
        
        if and((Iters > 2), (isequal(X, Xnew)))
            break
        end
        
        X = Xnew;
        
        for i=1:N           
            bMoved(i) = 0;
            bGoOn2 = true;
            while bGoOn2        
                disp(['Iterations ', num2str(Iters), ' Moving by i = ', num2str(i), ' Current point ', mat2str(Xnew)]);
                xx = Xnew(i);
                Xnew(i) = xx + StepSize(i);                
                F = feval(myFx, Xnew);
                if F < BestF
                    BestF = F;
                    bMoved(i) = 1;
                else
                    Xnew(i) = xx - StepSize(i);
                    F = feval(myFx, Xnew);
                    if F < BestF
                        BestF = F;
                        bMoved(i) = 1;
                    else
                        Xnew(i) = xx;
                        bGoOn2 = false;
                    end
                end                             
                
                values = [values; feval(myFx, Xnew)];
                path = [path, Xnew];
                
                for j = 1 : N
                   if or((Xnew(j) < lower(j)), (Xnew(j) > upper(j)));
                        X = Xnew;
                        i = N;
                        bGoOn2 = false;
                        bGoOn = false;
                        break
                    end  
                end               
            end             
        end   
        
        if ~bGoOn
            break
        end
        
        bMadeAnyMove = sum(bMoved);

        if bMadeAnyMove > 0
            DeltaX = Xnew - X;
            lambda = 0.5;
            lambda = linsearch(X, N, lambda, DeltaX, myFx);
            Xnew = X + lambda * DeltaX;
        end

        BestF = feval(myFx, Xnew);
        
        % reduce the step size for the dimensions that had no moves
        for i=1:N
            if bMoved(i) == 0
                StepSize(i) = StepSize(i) / 2;
            end
        end

        if abs(BestF - LastBestF) < Eps_Fx
            break
        end

        LastBest = BestF;
        bStop = true;
        for i=1:N
            if StepSize(i) >= MinStepSize(i)
                bStop = false;
            end
        end

        bGoOn = ~bStop;

    end
end

function y = myFxEx(N, X, DeltaX, lambda, myFx)

    X = X + lambda * DeltaX;
    y = feval(myFx, X);

end

function lambda = linsearch(X, N, lambda, D, myFx)
    MaxIt = 100;
    Toler = 0.000001;

    iter = 0;
    bGoOn = true;
    while bGoOn
        iter = iter + 1;
        if iter > MaxIt
            lambda = 0;
            break
        end

        h = 0.01 * (1 + abs(lambda));
        f0 = myFxEx(N, X, D, lambda, myFx);
        fp = myFxEx(N, X, D, lambda+h, myFx);
        fm = myFxEx(N, X, D, lambda-h, myFx);
        deriv1 = (fp - fm) / 2 / h;
        deriv2 = (fp - 2 * f0 + fm) / h ^ 2;
        diff = deriv1 / deriv2;
        lambda = lambda - diff;
        if abs(diff) < Toler
            bGoOn = false;
        end
    end
end