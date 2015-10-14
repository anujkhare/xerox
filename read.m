patient_vitals_living = cell(111, 1);
folder = '/root/code/xerox/vitals_living/';
files = dir([folder, '*.csv']);
for k = 1 : length(files)
    file_name = files(k).name;
    X = csvread([folder, file_name]);
    disp(size(X));
    patient_vitals_living(k) = X';
 end