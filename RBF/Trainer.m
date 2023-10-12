clc
clear 
close all
rng(1);
%% Setting Parameters    
    
    N = 4;  % number of anchors
    M = 225;  % number of mobile nodes
    USSpeed = 1540; %m/s Speed of ultraSonic Sound (C1)
    RFSpeed = 3*10^8; %m/s Speed of Radio Frequency (C2)

    networkSize = 100;  % we consider a 100by100 area that the mobile can wander
    
    anchorLoc   = [0                     0; % set the anchor at 4 vertices of the region
                   networkSize           0;
                   0           networkSize;
                   networkSize networkSize];

    % building a random location for the mobile node
    % mobileLoc  = networkSize*rand(M,2);
    mobileLoc = newDistribute1(M,networkSize);

    array=linspace(1,networkSize,sqrt(M));
    distMeasurementErrRatio = 0.1;
    
    
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
%     end

    
    % Computing the Euclidian distances    
    distance = zeros(N,M);
    for m = 1 : M
        for n = 1 : N
                distance(n,m) = sqrt( (anchorLoc(n,1)-mobileLoc(m,1)).^2 + ...
                                            (anchorLoc(n,2)-mobileLoc(m,2)).^2  );
        end
    end
    
    
    
    
        % Plot the scenario


    


    for n=1:N
        for m = 1 : M
            
            TOArf = distance (n,m)/RFSpeed;
            TOAus = distance (n,m)/USSpeed;
            TDOA = TOAus - TOArf;
            C =RFSpeed*USSpeed/(RFSpeed-USSpeed);
            dist(n,m) = TDOA*C;
             
        end
    end
    
    % noisy measurements
    dist = dist + dist.*distMeasurementErrRatio.*(rand(N,M)-1/2);
    
    net = newrb(dist,mobileLoc',50,350);
    
    for m = 1 : M

        mobileLocEst(m,:) = sim(net,dist(:,m));
        
    end    
    
        % Plot the scenario
    f1 = figure(1);
    clf
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    grid on
    hold on
    plot(mobileLoc(:,1),mobileLoc(:,2),'b+','MarkerSize',8,'lineWidth',2);
    
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
