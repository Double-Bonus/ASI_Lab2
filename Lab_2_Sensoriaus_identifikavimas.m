clear, close all

load duomenys_ANN_mokymui.txt % Load data to MATLAB

neuron_cnt = [1 2 3 4 5 6 7 8 9 10 20 30 50 70 100];
koef = 0.1:0.1:0.9; % coefficient  of what percentage is used for test data
finalExcelData = zeros(length(neuron_cnt), length(koef));
finalInd = 1;
reapeat_Cnt = 5; %to get average
errorSum = 0;

for koefLocal = koef
    Output = ['Now using ', num2str(koefLocal),' coefficient'] ;
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

            offset=sum(abs(OUTdataTEST-y));     %Calculate absolute offset
            errorSum = errorSum + offset;
        end
        finalExcelData(finalInd) = (errorSum/reapeat_Cnt)/dalinam; %relative offset, it's absolute offset devided
        ...by number of testing points
        finalInd = finalInd + 1;
    end 
end

figure(1) %Draw graph with software made sensors' data and real measurements in same window
plot(y,'-*'), hold on,
plot(OUTdataTEST,'-*r'),grid
legend('Jutiklio parodymai','Tikri duomenys')

figure(2) %plot offset in 2D graph
hold on;
grid on;
Markers = {'+','o','*','x','v','d','^','s','>'};
for i =1:9
    plot(neuron_cnt, finalExcelData(:,i), strcat('-',Markers{i}))
end
legend('koef = 0.1','koef = 0.2','koef = 0.3','koef = 0.4','koef = 0.5','koef = 0.6','koef = 0.7','koef = 0.8','koef = 0.9','','Location','NorthWest');
xlabel('Neuronu skaicius ','FontSize',12,'FontWeight','bold'); ylabel('Santykine paklaida ','FontSize',12,'FontWeight','bold');
title('Neuroninio tinklo paklaidos');

figure(3)
[X,Y] = meshgrid(koef,neuron_cnt);
surf(X,Y,finalExcelData) %to show data in 3D
