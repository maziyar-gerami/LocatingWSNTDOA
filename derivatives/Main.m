clc
clear 
close all
%% Setting Parameters    
    
    N = 4;  % number of anchors
    M = 225;  % number of mobile nodes
    
    % distance dependent err (standard deviation of the noise normalized to distance)
    distMeasurementErrRatio = 0.1;  % it means that the accuracy of distance measurement is 90 %
                                    % for instance the inaccuracy of a 1m measured distance
                                    % is around .1 meter.

    networkSize = 100;  % we consider a 100by100 area that the mobile can wander
    
    anchorLoc   = [0                     0; % set the anchor at 4 vertices of the region
                   networkSize           0;
                   0           networkSize;
                   networkSize networkSize];

    % building a random location for the mobile node
     % mobileLoc  = networkSize*rand(M,2);
     mobileLoc = newDistribute1(M,networkSize);
    
    
%     array=linspace(1,networkSize,sqrt(M));
%     counter=1;
%     for k=1: length(array)
%         for l=1:length(array)
%             
%             mobileLoc(counter,1) = array(k);
%             mobileLoc(counter,2) = array(l);
%             counter= counter+1;
%             
%         end
%         
%    end
    
    % Computing the Euclidian distances    
    distance = zeros(N,M);
    for m = 1 : M
        for n = 1 : N
                distance(n,m) = sqrt( (anchorLoc(n,1)-mobileLoc(m,1)).^2 + ...
                                            (anchorLoc(n,2)-mobileLoc(m,2)).^2  );
        end
    end
    % Plot the scenario
    f1 = figure(1);
    clf
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    grid on
    hold on
    plot(mobileLoc(:,1),mobileLoc(:,2),'b+','MarkerSize',8,'lineWidth',2);
    
    % noisy measurements
    distanceNoisy = distance + distance.*distMeasurementErrRatio.*(rand(N,M)-1/2);
    
    % using gussian newton to solve the problem
    % (http://en.wikipedia.org/wiki/Gauss%E2%80%93Newton_algorithm)
    
    numOfIteration = 5;
    
    % Initial guess (random locatio)
    mobileLocEst = networkSize*rand(M,2);
    % repeatation
    for m = 1 : M
        for i = 1 : numOfIteration
            % computing the esimated distances
            distanceEst   = sqrt(sum( (anchorLoc - repmat(mobileLocEst(m,:),N,1)).^2 , 2));
            % computing the derivatives
                % d0 = sqrt( (x-x0)^2 + (y-y0)^2 )
                % derivatives -> d(d0)/dx = (x-x0)/d0
                % derivatives -> d(d0)/dy = (y-y0)/d0
            distanceDrv   = [(mobileLocEst(m,1)-anchorLoc(:,1))./distanceEst ... % x-coordinate
                             (mobileLocEst(m,2)-anchorLoc(:,2))./distanceEst];   % y-coordinate
            % delta 
            delta = - (distanceDrv.'*distanceDrv)^-1*distanceDrv.' * (distanceEst - distanceNoisy(:,m));
            % Updating the estimation
            mobileLocEst(m,:) = mobileLocEst(m,:) + delta.';
        end
    end    
    plot(mobileLocEst(:,1),mobileLocEst(:,2),'ro','MarkerSize',8,'lineWidth',2);
    legend('Anchor locations','Mobile true location','Mobile estimated location',...
           'Location','Best')
    
    % Compute the Root Mean Squred Error
    Err = mean(sqrt(sum(((mobileLocEst-mobileLoc(1:M,:)).^2))))
    MSE = Err^2
    SD = abs(mean(mean((mobileLocEst-mobileLoc(1:M,:))/Err)))
    mdl = fitlm(distance',mobileLoc(1:M,1));
    xR = mdl.Rsquared.Adjusted;
    mdl = fitlm(distance',mobileLoc(1:M,2));
    yR = mdl.Rsquared.Adjusted;
    rsquare = (xR+yR)/2
    title(['Mean Estimation error is ',num2str(Err),'meter'])
    axis([-0.1 1.1 -0.1 1.1]*networkSize)