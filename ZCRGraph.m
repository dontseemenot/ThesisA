clc;clear;
ins1ZCR = load('ins1/sleepStageZCR.mat').sleepStageZCR;
ins1ZC = load('ins1/epochZC.mat').epochZC;
n2ZCR = load('n2/sleepStageZCR.mat').sleepStageZCR;
n2ZC = load('n2//epochZC.mat').epochZC;
%%
figure(1);

x = ["W" "N1" "N2" "N3" "N4" "REM"];
y = [ins1ZCR(:, 4), n2ZCR(:, 4)];
bar(y)
set(gca,'xticklabel',x.')

title('Mean zero crossings for different sleep stages');
legend('ID', 'HC');
xlabel('Sleep Stage');
ylabel('Mean zero crossings per epoch')