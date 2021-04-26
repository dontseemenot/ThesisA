Wake = {};
NREM1 = [];

fs = 256;
duration = 30;
nsamples = fs*duration;

WakeIndex = 1;
curStage = 0;
curStartIndex = 1;
curEndIndex = 1;
for i = 1:20
    if hyp(i) ~= curStage
        curEndIndex = i - 1;
        switch hyp(i)
            case 0
                
                Wake{WakeIndex, 1} = curStage;
                
                Wake{WakeIndex, 2} = dataArray(curStartIndex*(nsamples) :curEndIndex)
            case 1
                disp('1')
            case 2
        curStartIndex = i;
        curStage = hyp(i);
    end
end