disp("Take downward force as +ve and upward force as -ve, this has been done as usually more problems with downward forces are there");

% Asking if cantilever fixed from left or from right
leftRight=input("Is cantilever fixed from LHS or from RHS: ","s");

% Asking the units;
unitLength=input("What is the unit of length: ","s");
unitForce=input("What is the unit of force: ","s");
unitMoment=[unitForce,unitLength];

% Prompt the user to specify the length of the Cantilever
CantLength = input('Enter the length of the Cantilever: ');

% Prompt the user to specify the number of Concentrated Loads 
numConcLoads = input('Enter the number of Concentrated Loads: ');
% Prompt the user to specify the number of Uniformly distributed Loads 
numUdLoads = input('Enter the number of Uniformly Distributed Loads: ');

% Initialize arrays to store load values, distances, and lengths
ConcLoadValues = zeros(1, numConcLoads);
ConcLoadDistance = zeros(1, numConcLoads);
UdLoadValues = zeros(1, numUdLoads);
UdLoadLength = zeros(1, numUdLoads);
UdLoadDistance = zeros(1, numUdLoads);

% Prompt the user to input values for each concentrated load
for i = 1:numConcLoads
    ConcLoadValues(i) = input(['Enter the value for Concentrated Load ' num2str(i) ' with sign: ']);
end

% Prompt the user to input values for each UDL and ensure total length does not exceed cantilever length
for i = 1:numUdLoads
    while true
        UdLoadValues(i) = input(['Enter the value for Uniformly Distributed Load ' num2str(i) ' with sign: ']);
        UdLoadLength(i) = input(['Enter the length for Uniformly Distributed Load ' num2str(i) ': ']);
        UdLoadDistance(i) = input(['Enter the distance of Uniformly Distributed Load ' num2str(i) ' from LHS: ']);
        
        % Check for negative distance
        if UdLoadDistance(i) >= 0
            totalUdLoadLength = UdLoadDistance(i) + UdLoadLength(i);
            if totalUdLoadLength <= CantLength
                break;
            else
                disp('Error: Total length of UDLs exceeds cantilever length. Please enter valid lengths and distances.');
            end
        else
            disp('Error: Distance from the left-hand side (LHS) must be non-negative. Please enter a valid distance.');
        end
    end
end

% Prompt the user to specify the distance of Concentrated Loads from LHS
for i = 1:numConcLoads
    while true
        ConcLoadDistance(i) = input(['Enter the distance of Concentrated Load ' num2str(i) ' from LHS: ']);
        if ConcLoadDistance(i) >= 0 && ConcLoadDistance(i) <= CantLength
            break;
        else
            disp('Error: Load distance must be non-negative and not exceed cantilever length. Please enter a valid distance.');
        end
    end
end

if leftRight=='RHS'
    % Finding normal reactions at fixed end
    normalReaction=0;
    for i=1:numConcLoads
        normalReaction=normalReaction-ConcLoadValues(i);
    end
    for i=1:numUdLoads
        normalReaction=normalReaction-(UdLoadValues(i))*(UdLoadLength(i));
    end
    disp(['The normal Reaction at fixed end is ', num2str(normalReaction) , unitForce]);
    normalMomemt=0;
    for i=1:numConcLoads
        normalMomemt=normalMomemt+(ConcLoadValues(i))*(ConcLoadDistance(i));
    end
    for i=1:numUdLoads
        normalMomemt=normalMomemt+(UdLoadValues(i))*(UdLoadLength(i))*(UdLoadDistance(i)+((UdLoadLength(i)/2)));
    end
    disp(['The normal Moment at fixed end is ', num2str(normalMomemt) , unitMoment]);

    % Calculate the total shear force at each point along the beam
    totalShearForce = 0;
    x=linspace(0,CantLength,1000);            
    for i = 1:numConcLoads
        totalShearForce = totalShearForce - ConcLoadValues(i) * (x>ConcLoadDistance(i));
    end
    for i = 1:numUdLoads
        totalShearForce = totalShearForce - UdLoadValues(i)*(x-UdLoadDistance(i)).*(x>UdLoadDistance(i))+UdLoadValues(i)*(x-(UdLoadDistance(i)+UdLoadLength(i))).*(x>(UdLoadDistance(i)+UdLoadLength(i))) ;
    end
    
    %subplot(111);
    %plot(x,totalShearForce);
    
    % Calculate the total bending moment at each point along the beam
    totalBendingMoment = 0;
    for i = 1:numConcLoads
        totalBendingMoment = totalBendingMoment -ConcLoadValues(i).*(x-ConcLoadDistance(i)).*(x>ConcLoadDistance(i));
    end
    for i = 1:numUdLoads
        totalBendingMoment = totalBendingMoment -((UdLoadValues(i))/2)*(x-UdLoadDistance(i)).^2.*(x>UdLoadDistance(i))+((UdLoadValues(i))/2)*(x-(UdLoadDistance(i)+UdLoadLength(i))).^2.*(x>(UdLoadDistance(i)+UdLoadLength(i)));
    
    end

    %Plot the Shear Force Diagram
    figure;
    subplot(2, 1, 1);
    plot(x, totalShearForce, 'b-', 'LineWidth', 1.5);
    title('Shear Force Diagram');
    xlabel(['Beam Length (' unitLength ')']);
    ylabel(['Shear Force (' unitForce ')']);
    grid on;
    
    %Plot the Bending Moment Diagram
    subplot(2, 1, 2);
    plot(x, totalBendingMoment, 'r-', 'LineWidth', 1.5);
    title('Bending Moment Diagram');
    xlabel(['Beam Length (' unitLength ')']);
    ylabel(['Bending Moment (' unitMoment ')']);
    grid on;

elseif leftRight=='LHS'
    normalReaction=0;
    for i=1:numConcLoads
        normalReaction=normalReaction-ConcLoadValues(i);
    end
    for i=1:numUdLoads
        normalReaction=normalReaction-(UdLoadValues(i))*(UdLoadLength(i));
    end
    disp(['The normal Reaction at fixed end is ', num2str(normalReaction), unitForce]);
    normalMomemt=0;
    for i=1:numConcLoads
        normalMomemt=normalMomemt+(ConcLoadValues(i))*(ConcLoadDistance(i));
    end
    for i=1:numUdLoads
        normalMomemt=normalMomemt+(UdLoadValues(i))*(UdLoadLength(i))*(UdLoadDistance(i)+((UdLoadLength(i)/2)));
    end
    disp(['The normal Moment at fixed end is ', num2str(normalMomemt), unitMoment]);
    
    % Calculate the total shear force at each point along the beam
    totalShearForce =-normalReaction;
    x=linspace(0,CantLength,1000);            
    for i = 1:numConcLoads
        totalShearForce = totalShearForce - ConcLoadValues(i) * (x>ConcLoadDistance(i));
    end
    for i = 1:numUdLoads
        totalShearForce = totalShearForce - UdLoadValues(i)*(x-UdLoadDistance(i)).*(x>UdLoadDistance(i))+UdLoadValues(i)*(x-(UdLoadDistance(i)+UdLoadLength(i))).*(x>(UdLoadDistance(i)+UdLoadLength(i))) ;
    end

    % Calculate the total bending moment at each point along the beam
    totalBendingMoment =-normalMomemt-normalReaction*x;
    for i = 1:numConcLoads
        totalBendingMoment = totalBendingMoment -ConcLoadValues(i).*(x-ConcLoadDistance(i)).*(x>ConcLoadDistance(i));
    end
    for i = 1:numUdLoads
        totalBendingMoment = totalBendingMoment -((UdLoadValues(i))/2)*(x-UdLoadDistance(i)).^2.*(x>UdLoadDistance(i))+((UdLoadValues(i))/2)*(x-(UdLoadDistance(i)+UdLoadLength(i))).^2.*(x>(UdLoadDistance(i)+UdLoadLength(i)));

    end

    %Plot the Shear Force Diagram0
    
    figure;
    subplot(2, 1, 1);
    plot(x, totalShearForce, 'b-', 'LineWidth', 1.5);
    title('Shear Force Diagram');
    xlabel(['Beam Length (' unitLength ')']);
    ylabel(['Shear Force (' unitForce ')']);
    grid on;
    
    %Plot the Bending Moment Diagram
    subplot(2, 1, 2);
    plot(x, totalBendingMoment, 'r-', 'LineWidth', 1.5);
    title('Bending Moment Diagram');
    xlabel(['Beam Length (' unitLength ')']);
    ylabel(['Bending Moment (' unitMoment ')']);
    grid on

else 
    print('Please tell whether fixed end is LHS or RHS')

end