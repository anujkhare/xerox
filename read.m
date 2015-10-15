%patient_vitals_dead = cell(111, 1);
%folder = '/root/code/xerox/vitals_dead/';
%files = dir([folder, '*.csv']);
%for k = 1 : length(files)
%    file_name = files(k).name;
%    X = csvread([folder, file_name]);
%    disp(size(X));
%    patient_vitals_dead(k) = X';
% end
% 
% 
% patient_vitals_living = cell(111, 1);
%folder = '/root/code/xerox/vitals_living/';
%files = dir([folder, '*.csv']);
%for k = 1 : length(files)
%    file_name = files(k).name;
%    X = csvread([folder, file_name]);
%    disp(size(X));
%    patient_vitals_living(k) = X';
% end 

patients_dead = cell(111, 1);
folder = '/root/code/xerox/patient_dead/';
files = dir([folder, '*.csv']);
for k = 1 : length(files)
  file_name = files(k).name;
  X = csvread([folder, file_name]);
  disp(size(X));
  patients_dead(k) = X';
end 

patients_living = cell(111, 1);
folder = '/root/code/xerox/patient_living/';
files = dir([folder, '*.csv']);
for k = 1 : length(files)
  file_name = files(k).name;
  X = csvread([folder, file_name]);
  disp(size(X));
  patients_living(k) = X';
end