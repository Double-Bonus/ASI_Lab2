clear all, close all
% Load data to MATLAB
load duomenys_ANN_mokymui.txt


neuron_cnt = [1 2 3 4 5 6 7 8 9 10 20 30 50 70 100];
koef = 0.1:0.1:0.9; % coeeficent of what percentage is used for test data
finalExcelData = zeros(length(neuron_cnt), length(koef));
finalInd = 1;
reapeat_Cnt = 5;
errorSum = 0;

for koefLocal = koef
    Output = ['Now using ', num2str(koefLocal),' coeficent'] ;
    disp(Output);
    % Suskirstome i mokymo ir testavimo
    % Divide data training and testing
    ind=randperm(size(duomenys_ANN_mokymui,1)); %Gives index in random order !!!!!CAN CHANGE SEED
    dalinam=round(size(duomenys_ANN_mokymui,1)*koefLocal); %we change porporsion of train and test data 
    TESTdata=duomenys_ANN_mokymui(ind(1:dalinam),:); %nuo pirmo iki dalinam indekso
    TRAINdata=duomenys_ANN_mokymui(ind(dalinam+1:end),:);

    % Paskirstome  iejimus (IN) ir isejimus (OUT)
    INdataTEST=TESTdata(:,2:3)'; %iejimas i neuronini tinkla
    OUTdataTEST=TESTdata(:,4)';
    INdataTRAIN=TRAINdata(:,2:3)';
    OUTdataTRAIN=TRAINdata(:,4)';

    for neuron_ind = 1: length(neuron_cnt) %make another for inside this
        errorSum = 0;
        for ii = 1:reapeat_Cnt
        % Treniruojam jutikl? uzduodami pasl?pt? neuron? skai?i? 
        net = feedforwardnet(neuron_cnt(neuron_ind),'trainlm'); % we change number of neurons
        net = train(net,INdataTRAIN,OUTdataTRAIN);

        % Testuojame su testavimo imtimi t.y. niekada nematyta
        y = net(INdataTEST);  %cia irgi

        % Suskai?iuojam absoliutin? sumin? paklaid?
        paklaida=sum(abs(OUTdataTEST-y));
        errorSum = errorSum + paklaida;
        end
        
        finalExcelData(finalInd) = (errorSum/reapeat_Cnt)/dalinam;
        finalInd = finalInd + 1;
    end 

 %finalExcel(%indFinal) = paklaidosVid; indFinal++;
end
% Atbr?ziam grafik? programinio jutiklio ir tikr? matavim? viename langa 
figure(1)
plot(y,'-*'),hold on, % Islaikome grafik?, nes norime ant to paties lango br?zti kit?
plot(OUTdataTEST,'-*r'),grid	% Br?ziam tikrus matavimus ir uzdedam tinklel?
legend('Jutiklio parodymai','Tikri duomenys') % priskiriame grafik? pavadinimus

figure(3)
[X,Y] = meshgrid(koef,neuron_cnt);
surf(X,Y,finalExcelData)



%PABAIGOJE
%csvwrite(0 <file name>0 , A) Writes out the elements of a matrix to the named file using the
%same format as csvread
