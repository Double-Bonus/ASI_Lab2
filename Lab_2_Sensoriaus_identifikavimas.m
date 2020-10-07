clear, close all

load duomenys_ANN_mokymui.txt % Load data to MATLAB

neuron_cnt = [1 2 3 4 5 6 7 8 9 10 20 30 50 70 100];
koef = 0.1:0.1:0.9; % coeeficent of what percentage is used for test data
finalExcelData = zeros(length(neuron_cnt), length(koef));
finalInd = 1;
reapeat_Cnt = 5; %to get average
errorSum = 0;

for koefLocal = koef
    Output = ['Now using ', num2str(koefLocal),' coeficent'] ;
    disp(Output);
    % Divide data into training and testing
    ind=randperm(size(duomenys_ANN_mokymui,1)); %Gives index in random order
    dalinam=round(size(duomenys_ANN_mokymui,1)*koefLocal); %we change porporsion of train and test data 
    TESTdata=duomenys_ANN_mokymui(ind(1:dalinam),:);
    TRAINdata=duomenys_ANN_mokymui(ind(dalinam+1:end),:);

    % Divide  input (IN) and output (OUT) data
    INdataTEST=TESTdata(:,2:3)'; %input to neuron net
    OUTdataTEST=TESTdata(:,4)';
    INdataTRAIN=TRAINdata(:,2:3)';
    OUTdataTRAIN=TRAINdata(:,4)';

    for neuron_ind = 1: length(neuron_cnt)  % we change number of neurons
        errorSum = 0;
        for ii = 1:reapeat_Cnt
            % Train our sensor with neuron net
            net = feedforwardnet(neuron_cnt(neuron_ind),'trainlm');
            net = train(net,INdataTRAIN,OUTdataTRAIN);  

            y = net(INdataTEST);  %Testing with data never seen by net

            paklaida=sum(abs(OUTdataTEST-y));     %Calculate absolute offset
            errorSum = errorSum + paklaida;
        end        
        finalExcelData(finalInd) = (errorSum/reapeat_Cnt)/dalinam; %relative offset, it's absolute offset devided
        ...by number of testing points
        finalInd = finalInd + 1;
    end 
end

%Draw graph with software made sensors' data and real measurments in same window
figure(1)
plot(y,'-*'), hold on,
plot(OUTdataTEST,'-*r'),grid
legend('Jutiklio parodymai','Tikri duomenys')

figure(3)
[X,Y] = meshgrid(koef,neuron_cnt);
surf(X,Y,finalExcelData) %to show data in 3D
