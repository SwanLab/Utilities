function     I = postprocessGIDopt(fname,case_name,algorithm,user_paths)

%% Initial data
down_path = user_paths.temp_folder;

% Copy file to temporal path
[org_path,file,ext] = fileparts(fname);
res_file = [down_path,'/',file,ext];
msh_file = [down_path,'/',file,'.msh'];
copyfile(fname,down_path,'f');
fname = [org_path,'/',file,'.msh'];
copyfile(fname,down_path,'f');

% Path with GID view files

view_path = [user_paths.mfilepath,'Views'];

% Function to fix directions
fixdir = @(str) strrep(str,'\','/');

% Save image
png_file = [down_path,'/topology.png'];

%% Run GID
% Filter cases
case_name = strrep(case_name,'New','');
[gid_case,corners,symcase,view_file,case_name] = get_gid_macro_cases(case_name);
if gid_case == 0 % no symmetry
    macro_name = 'NoSym';
elseif gid_case == 1 % single symmetry
    macro_name = 'SingleSym';
elseif gid_case == 2 % double symmetry
    macro_name = 'DoubleSym';
elseif gid_case == 3 % RVE Hexagonal
    macro_name = 'TripleSym';
else
    error('Case not included yet.');
end

if ~strcmp('level_set',algorithm)
    macro_name = [macro_name,'_PG'];
end

view_file = [view_path,'\',view_file]; 

%% Call GID
fix_macros_GID(user_paths);
if ispc % WINDOWS
    command = sprintf('start /wait %s -t "::toolbarmacros::macrospace::PNG%s "%s" "%s" "%s" %s %s "', ...
                      user_paths.gid_path,macro_name,fixdir(res_file),fixdir(view_file),fixdir(png_file),corners,symcase);
    dos(command);
elseif isunix % LINUX
     command = sprintf('%s -t "::toolbarmacros::macrospace::PNG%s "%s" "%s" "%s" %s %s "', ...
                      user_paths.gid_path,macro_name,fixdir(res_file),fixdir(view_file),fixdir(png_file),corners,symcase);
     unix(command);
else
    error('Operating system not included!.');
end

%% Read image
I = imread(png_file);

% Crop image
if ~isempty(strfind(case_name,'CantiliberbeamSym'))
    rect = 1e3*[0.04951 0.04851 1.58598 0.79098];
elseif ~isempty(strfind(case_name,'BridgeSimetric'))
    rect = 1e3*[0.00951 0.16451 1.69798 0.56498];
elseif ~isempty(strfind(case_name,'Gripping'))
    rect = 1e2*[4.2251 0.0851 8.809800000000001 8.799799999999999];
elseif ~isempty(strfind(case_name,'Square')) % also for RVE_Square
    rect = 1e2*[4.2051 0.0951 8.7698 8.7698];
elseif ~isempty(strfind(case_name,'RVE_Hexagonal'))
    rect = 1e2*[4.4951 0.1051 8.1398 8.7198];
elseif ~isempty(strfind(case_name,'Bicycle'))
    rect = 1e3*[0.00051 0.08951 1.70998 0.71198];
elseif ~isempty(strfind(case_name,'TrencalosSupport'))
	rect = 1e3*[0.30651 0.01151 1.10498 0.84998 ];
elseif ~isempty(strfind(case_name,'CantileverExampleProblem'))
	rect = 1e3*[0.01051 0.22251 1.69898 0.42498 ];
else
    warning('This case is not included yet to crop.');
    figure;
    format long
    [~,rect] = imcrop(I);
    fprintf('If crop was correctly done, please add following case\n(introducing the correct KEYWORD for the case):\n\n');
    fprintf('elseif ~isempty(strfind(case_name,''');
    message = 'KEYWORD';
    try
        cprintf('_green','%s',message);
    catch ME
        warning('cprintf failed!');
        fprintf('%s',message);
    end
    fprintf('''))\n');
    fprintf('\trect = 1e3*[');
    fprintf('%g ',rect/1e3);
    fprintf('];\n\n');
    edit postprocessGIDopt.m
    hEditor = matlab.desktop.editor.getActive;
    hEditor.goToLine(59)
end
I = imcrop(I,rect);
      
%% Delete temporal files
delete(res_file);
delete(msh_file);
delete(png_file);

end
