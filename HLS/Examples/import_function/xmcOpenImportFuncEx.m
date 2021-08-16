addpath(fileparts(get_param(bdroot,'FileName')))
[filepath,~,~] = fileparts(get_param(bdroot,'FileName'));
cd(fullfile(filepath,get_param(gcb,'ex_folder')));
m = dir('func*.slx');
open(m.name)
set_param(gcs, 'location', [50 100 1000 750])
set_param(gcs, 'ZoomFactor', 'FitSystem')