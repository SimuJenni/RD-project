function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.s
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 18-May-2016 18:04:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

%%  Setup stuff
setup;
handles.resultsFolder = resultsDir;
DirList = dir([handles.resultsFolder 'ROI*']); 

% ROI popup
ROIList = cell(1, length(DirList));
for Index = 1:length(DirList);
    ROIList{Index} = DirList(Index).name;
end

if isempty(ROIList)
    error('Empty results folder! Run demo.m first to generate some results.');
end

% Video popup
FileList = struct;
FileList.names = {};
FileList.ROIs = {};
ListDir = {};
% Get list of video for every ROI, in case some videos have not been anaylized with every ROI
for Index = 1:length(ROIList)
    ListDir = dir([handles.resultsFolder ROIList{Index} '/*.mat']);
    FileList.names = unique([FileList.names {ListDir.name}], 'stable');
    for idx = 1:length(ListDir)
        [~, indexOfMember] = ismember(ListDir(idx).name, FileList.names);
        try
            FileList.ROIs{indexOfMember} = [FileList.ROIs{indexOfMember} ROIList{Index}];
        catch
            FileList.ROIs{indexOfMember} = {ROIList{Index}};
        end
    end
end
set(handles.popup_video,'string',FileList.names);
if isempty(FileList)
    error('Empty results folder!');
end
handles.selectedVideo = FileList.names{1};
handles.ROISize = char(FileList.ROIs{1}(1));
set(handles.popup_roi,'string',FileList.ROIs{1});

% Others
handles.activityFFT = true;
handles.selectedROI = [1, 1];
handles.spectrum_stat_type = 'Mean Spectrum';
handles.lrPlot_stat_type = 'Histogram of frequencies';
handles.lq = 0.0;
handles.hq = 1.0;
handles.videos = FileList;

% Update handles structure
guidata(hObject, handles);
handles = updateData(hObject, handles);
updateAll(hObject, handles);


% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popup_video.
function popup_video_Callback(hObject, eventdata, handles)
% hObject    handle to popup_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_video contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_video
contents = cellstr(get(hObject,'String'));
handles.selectedVideo = [contents{get(hObject,'Value')}];

% Error handling in case the choice of ROI size is bad.
[~, indexOfMember] = ismember(handles.selectedVideo, handles.videos.names);
set(handles.popup_roi,'string',handles.videos.ROIs{indexOfMember});
[member, ~] = ismember(handles.ROISize, handles.videos.ROIs{indexOfMember});
if ~member
    set(handles.popup_roi, 'value', 1);
    handles.ROISize = char(handles.videos.ROIs{indexOfMember}(1));
    set(handles.popup_roi,'string',handles.videos.ROIs{indexOfMember});
    errordlg('The selected ROI size is not valid. Please select another one','!! Error !!')   
end
handles = updateData(hObject, handles);
updateAll(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popup_video_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_mask_upper.
function popup_mask_upper_Callback(hObject, eventdata, handles)
% hObject    handle to popup_mask_upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_mask_upper contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_mask_upper
contents = cellstr(get(hObject,'String'));
handles.hq = str2double(contents{get(hObject,'Value')});
updateAll(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popup_mask_upper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_mask_upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_mask_lower.
function popup_mask_lower_Callback(hObject, eventdata, handles)
% hObject    handle to popup_mask_lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_mask_lower contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_mask_lower
contents = cellstr(get(hObject,'String'));
handles.lq = str2double(contents{get(hObject,'Value')});
updateAll(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popup_mask_lower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_mask_lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_mask.
function checkbox_mask_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_mask


% --- Executes on selection change in popup_spectrum.
function popup_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to popup_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_spectrum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_spectrum
contents = cellstr(get(hObject,'String'));
handles.spectrum_stat_type = contents{get(hObject,'Value')};
updateAll(hObject, handles)

% --- Executes during object creation, after setting all properties.
function popup_spectrum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_entropy_activity.
function button_entropy_activity_Callback(hObject, eventdata, handles)
% hObject    handle to button_entropy_activity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activityFFT = false;
updateAll(hObject, handles);


% --- Executes on button press in button_fft_activity.
function button_fft_activity_Callback(hObject, eventdata, handles)
% hObject    handle to button_fft_activity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activityFFT = true;
updateAll(hObject, handles);


% --- Executes on selection change in popup_roi.
function popup_roi_Callback(hObject, eventdata, handles)
% hObject    handle to popup_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_roi contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_roi
contents = cellstr(get(hObject,'String'));
handles.ROISize = contents{get(hObject,'Value')};
handles.selectedROI = [1 1; 1 1];
handles = updateData(hObject, handles);
updateAll(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popup_roi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function activity_plot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to activity_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.activity_plot);
currPoint = ceil(get(gca,'currentpoint'));
imSize = size(handles.data.activity);
handles.selectedROI(1) = axes2pix(imSize(1),[1, imSize(1)],  currPoint(1, 1));
handles.selectedROI(2) = axes2pix(imSize(2),[1, imSize(2)],  currPoint(1, 2));
updateAll(hObject, handles);

% --- Executes during object creation, after setting all properties.
function activity_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to activity_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate activity_plot

function handles = updateData(hObject, handles)
currentDataPath = [handles.resultsFolder handles.ROISize '/' ...
                   handles.selectedVideo];
handles.data = load(currentDataPath);


function updateAll(hObject, handles)
data = handles.data;

% Activity
axes(handles.activity_plot);
if handles.activityFFT
    generateActivityImage( fftPowerActivity(data.fftPower), 'Activity: FFT-Power' );
else
    generateActivityImage( data.activity, 'Activity: Entropy' );
end
set(gcf,'WindowButtonDownFcn',@(hObject,eventdata)gui('activity_plot_ButtonDownFcn',hObject,eventdata,guidata(hObject)))
hold on
plot(handles.selectedROI(1), handles.selectedROI(2),'r.','MarkerSize',20)
hold off

% The mask
axes(handles.mask);
mask = activityMask( data.activity, handles.lq, handles.hq );
imagesc(mask);
title('Activity Mask');

% Average or max spectrum over mask
axes(handles.spectrum_stat);
switch handles.spectrum_stat_type
    case 'Mean Spectrum'
        meanPower = mean(mean(data.fftPower,2),3);
        spectrumPlot( meanPower, data.freqs, 'Average CBF Spectrum' )
    case 'Mean Spectrum (mask)'
        maskedPower = data.fftPower(:,mask);
        meanPower = mean(maskedPower,2);
        spectrumPlot( meanPower, data.freqs, 'Average CBF Spectrum (Masked)' )
    case 'Maximum Spectrum'
        [~, idx] = max(data.activity(:));
        [row,col] = ind2sub([size(data.fftPower,2), size(data.fftPower,3)], idx);
        spectrumPlot( data.fftPower(:,row,col), data.freqs, 'Max Activity Spectrum' )
    case 'Maximum Spectrum (mask)'
        [~, idx] = max(data.activity(:).*mask(:));
        [row,col] = ind2sub([size(data.fftPower,2), size(data.fftPower,3)], idx);
        spectrumPlot( data.fftPower(:,row,col), data.freqs, 'Max Activity Spectrum (Masked)' )
    case 'Frequency Image'
        dominantFrequencyImage( data.dominantFreqs, 'Dominant Frequencies per ROI' );
    case 'Phase Image'
        dominantPhaseImage( data.dominantPhase, 'Dominant Phase per ROI' );
end   

% Lower right plot
axes(handles.histogram);
switch handles.lrPlot_stat_type
    case 'Histogram of frequencies'
        % Distribution of dominant frequencies
        maskedFreqs = data.dominantFreqs(mask);
        histogram(maskedFreqs(maskedFreqs<46),100);
        xlabel('Frequency (Hz)')
        ylabel('Count')
        title('{\bf Dominant Frequencies per ROI (Masked)}')    
    case 'Histogram of phases'
        % Distribution of dominant phases
        maskedPhases = data.dominantPhase(mask);
        histogram(maskedPhases,100);
        xlabel('Phase (rad)')
        ylabel('Count')
        title('{\bf Dominant Phases per ROI (Masked)}')
    case 'Frequency Image'
        dominantFrequencyImage( data.dominantFreqs, 'Dominant Frequencies per ROI' );
    case 'Phase Image'
        dominantPhaseImage( data.dominantPhase, 'Dominant Phase per ROI' );
end   

% Selected ROI
axes(handles.spectrum_selected);
try
    spectrumPlot( data.fftPower(:,handles.selectedROI(2),... 
        handles.selectedROI(1)), data.freqs, 'Selected Spectrum' )
catch
    handles.selectedROI
    disp('hmm')
end

guidata(hObject, handles);


% --- Executes on selection change in popup_histogram.
function popup_histogram_Callback(hObject, eventdata, handles)
% hObject    handle to popup_histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_histogram contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_histogram
contents = cellstr(get(hObject,'String'));
handles.lrPlot_stat_type = contents{get(hObject,'Value')};
updateAll(hObject, handles)

% --- Executes during object creation, after setting all properties.
function popup_histogram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
