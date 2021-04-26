

fileName = 'n2.edf';
signalLabel = 'Fp2-F4';

info = edfinfo(fileName);
data = edfread(fileName, 'SelectedSignals', signalLabel);
data = table2array(data);
data = vertcat(data{:});

