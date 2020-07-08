% function[vO,vObj]=VideoReaderType(fn,vO)
%
% this checks to see which VideoReader to use for the video file fn
% 
% outputs: vO=1 if using videoReader, or vO=0 if using mmread (slow) or mat
% files, vObj returns the video object from VideoReader or [] if not.
% it will default to using mat-files, then look to see if VideoReader
% exists and if it throws an error. If it doesn't function it then defaults
% to mmread
%
% The outputs work as inputs to MyAviRead and there are 3 options
% 
% 1. Use VideoReader. This is fast but has problems with some codecs and
% old versions of matlab
% 
% 2. It could use mmread. This is very robust, especially for old versions 
% of matlab but super slow for long files. Because of slowness, it is bette
% to pre-run mmread and store the data from each file in a matlab file. 
% This is done by the function AvisToMats2012 which stores the files in a
% folder that is named fn
% 
% 3. it could use the mat-files stored by AvisToMats2012
%
% the function runs and displays messages saying which option it is using
%
% option 3 is the quickest because it takes a while to generate a
% videoreader object for big movie files so it defaults to using mat files 
% if the correct folder (ie named fn) exists
% 
% However you can force it to use videoReader by setting the input vO=1 
% 
% Alternatively, setting vO=0 means to use mmread (slow) or mat files 
% Use the second option if you're still getting odd errors from VideoReader 
%
% USAGE:
% [vO,vObj]=VideoReaderType(fn) % gets the appropriate vObj and vO
% [vO,vObj]=VideoReaderType(fn,1) % this gets vO/vObj but tries to use VideoReaderusing vObj if vO=1
%
% im=MyAviRead(fn,10,vObj)  % use vObj to read frame 10 from fn

function[vO,vObj]=VideoReaderType(fn,vO)
vObj=[];

if(nargin==2)
    if(vO==1)
        disp('User has specified to try to use VideoReader')
    else
        disp('User has specified to try to use mmread/mat files')
    end
end

% check if the avi file is in the folder
% in either case, check to see if there is a folder with the mat files in
% from AvisToMats and default to using this (as takes a while to load the
% vObj from Videoreader
if(~exist(fn,'file'))
    disp(' ');
    disp(['*** CANNOT FIND FILE ' fn ' ***']);
    if(isdir(fn(1:end-4)))
        disp('*** using data from mat files ***')
    else
        disp('*** Check you are in the right directory ***');
        disp('*** Or whether you need to re-run AvisToMats 2012 ***');
    end
    disp(' ');
    vO=0;
    return
else
    if(isdir(fn(1:end-4)))
        if((nargin==1)||(vO~=1))
            disp('*** USING DATA FROM MAT FILES ***')
            disp(' ');
            vO=0;
            return
        end
    end
end

% this checks if the function VideoReader exists
if(nargin<2)
    if exist('VideoReader')
        vO=1;
    else
        vO=0;
        disp('*** VideoReader not on this matlab ***')
    end
end

% this chceks if VideoReader throws an error
if(vO)
    try 
        disp('loading file as VideoReader object...')
        vObj=VideoReader(fn);
    catch 
        vObj=[];
        vO=0;
        disp(['*** VideoReader doesnt work for ' fn ' ***'])
    end
    % this checks if read throws an error
    if(vO)
        try
            read(vObj,1);
        catch
            vObj=[];
            vO=0;
            disp(['*** VideoReader doesnt work for ' fn ' ***'])
        end
    end    
end
disp('... done')

if(~vO)
    if(isdir(fn(1:end-4)))
        disp('*** USING DATA FROM MAT FILES ***')
    else
        disp('*** USING MMREAD. THIS WILL BE SLOW FOR LONG FILES ***')
        disp('*** CONSIDER RUNNING AvisToMats2012.m ***')
    end
else
    disp('*** USING VIDEOREADER ***')
end
disp(' ')
