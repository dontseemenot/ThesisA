%% Get data
eegStartDateTime = sprintf('%s %s', info.StartDate, info.StartTime);
t1 = datetime(eegStartDateTime, 'InputFormat', 'dd.MM.yy HH.mm.ss');
t2 = datetime(labelledStartDateTime, 'InputFormat', 'dd/MM/yy HH.mm.ss');
labelledStartSecond = seconds(t2-t1);
dataPreP = data(labelledStartSecond + 1:labelledStartSecond + (hyp(end, 2) + 30)*256);
% static vars
fs = 256;
epochLength = 30;   % 30 seconds
numDataPointsTotal = length(dataPreP);
numEpochs = length(hyp);
numDataPointsEpoch = fs*epochLength;
maxV = 250;

% Remove > 250uv
epochs = {};
dataP = []; % data in processing
hypP = [];
j = 1;
for i = 1:numEpochs
    ai = (i - 1)*numDataPointsEpoch + 1; % 30s intervals
    bi = i*numDataPointsEpoch;
    aj = (j - 1)*numDataPointsEpoch + 1;
    bj = j*numDataPointsEpoch;
    if max(dataPreP(ai:bi)) < 250 && min(dataPreP(ai:bi)) > -250
        dataP(aj:bj) = dataPreP(ai:bi);
        hypP(j, :) = hyp(i, :);
        j = j + 1;
    end
end
tempP = dataP;
% Construct 7th order Butterworth filter with 40Hz cut-off
order = 7;
fc = 40;
wn = fc/(fs/2); % normalised frequency
[B, A] = butter(order, wn);
dataP = filter(B, A, dataP);
% Normalising
dataP = normalize(dataP);
% Renaming
hypPostP = hypP;
dataPostP = dataP;
clear dataP; clear hypP;
numEpochsPostP = length(hypPostP);

% Divide into 30s epochs
epochs = {};
j = 1;
for i = 1:numEpochsPostP
    ai = (i - 1)*numDataPointsEpoch + 1; % 30s intervals
    bi = i*numDataPointsEpoch;
    epochs{j, 1} = hypPostP(i, 1);
    epochs{j, 2} = dataPostP(ai:bi);
    j = j + 1;
end

%% Plot entire signal pre-process and post-process
t = 0:1/fs/3600:((length(dataPreP))/fs - 1/fs)/3600;    % hours
figure(1);
subplot(2, 1, 1);
plot(t, dataPreP);
title('ins1 EEG time domain pre-process');
xlabel('Hours');
ylabel('Volts (uV)');
mean(dataPreP)

t = 0:1/fs/3600:((length(dataPostP))/fs - 1/fs)/3600;
subplot(2, 1, 2);
plot(t, dataPostP);
title('ins1 EEG time domain post-process');
xlabel('Hours');
ylabel('Volts (uV)');
mean(dataPostP)
%% Plot a section of signal pre and post process
figure(3)
subplot(2,1,1)
gg = 92160;

plot(dataPreP(gg - 256*30 :gg + 256*30*2))
title('ins1 epoch #11-13 EEG time domain pre-process');
xlabel('Epoch sample number');
ylabel('Volts (uV)');

subplot(2,1,2)
plot(dataPostP(gg -256*30: gg + 256*30))
title('ins1 epoch #11-12 EEG time domain post-process');
xlabel('Epoch sample number');
ylabel('Volts (uV)');

%% FFT of original signal
L = length(dataPreP);
fftDataArray = fft(dataPreP);  % bin frequencies
P2 = abs(fftDataArray/L);
P1 = P2(1:L/2 + 1);
P1(2:end - 1) = 2*P1(2:end - 1);
f = fs*(0:(L/2))/L;
figure(2);
subplot(2, 1, 1);
plot(f, P1)
title('ins1 EEG frequency domain pre-process');
xlabel('f (Hz)');
ylabel('|A(f)|');
xlim([0 100]);

L = length(dataPostP);
fftDataArray = fft(dataPostP);  % bin frequencies
P2 = abs(fftDataArray/L);
P1 = P2(1:L/2 + 1);
P1(2:end - 1) = 2*P1(2:end - 1);
f = fs*(0:(L/2))/L;
figure(2);
subplot(2, 1, 2);
plot(f, P1)
title('ins1 EEG frequency domain post-process');
xlabel('f (Hz)');
ylabel('|A(f)|');
xlim([0 100]);

%% Plot individual epochs
k = 13;
t = 0:1/fs:epochLength - 1/fs;
plot(t, epochs{k, 2});
s = sprintf('Original EEG data stage %s epoch #%s', num2str(epochs{k, 1}), num2str(k));
title(s);
xlabel('Seconds');
ylabel('Volt (uV)');