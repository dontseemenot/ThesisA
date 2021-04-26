%% Calculate zero crossing rate
epochZC = [];
for i = 1:length(epochs)
    epochZC(i, 1) = epochs{i, 1};
    epochZC(i, 2) = ZC(epochs{i, 2});
end
% Format: Sleep Stage, # ZC, # epochs, ZCR (= ZC/epochs)
sleepStageZCR(1:6, 1) = sleepStageInfo(1:6, 1);
sleepStageZCR(1:6, 2) = 0;
sleepStageZCR(1:6, 3) = sleepStageInfo(1:6, 2);

for i = 1:length(epochZC)
    sleepStageZCR(epochZC(i, 1) + 1, 2) = sleepStageZCR(epochZC(i, 1) + 1, 2) + epochZC(i, 2);
end

for i = 1:length(sleepStageZCR)
    if sleepStageZCR(i, 2) == 0 || sleepStageZCR(i, 3) == 0
        sleepStageZCR(i, 4) = 0;
    else
        sleepStageZCR(i, 4) = sleepStageZCR(i, 2) / sleepStageZCR(i, 3);
    end
end

function numZC = ZC(x)
    numZC = 0;   % Counter for number of times the signal crosses zero voltage
    signCur = customSign(x(1)); % Measure first sampled point if it is positive or negative. Save this as the current sign of the signal.
    for n = 2:length(x)
        if customSign(x(n)) ~= signCur     % Signal polarity changes, so a zero crossing possibly occurred
            numZC = numZC + 1;
            signCur = customSign(x(n));
        end
    end
end
function ret = customSign(x)
    if sign(x) == 1 || sign(x) == 0
        ret = 1;
    else
        ret = 0;
    end
end
