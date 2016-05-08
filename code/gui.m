function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
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

% Last Modified by GUIDE v2.5 06-May-2016 17:11:28

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
set(handles.popup_roi,'string',ROIList);
handles.ROISize = ROIList{1};

% Video popup
FileList = dir([handles.resultsFolder ROIList{1} '/*.mat']); 
ListOfImageVideos = cell(1, length(FileList));
for Index = 1:length(FileList)
    baseFileName = FileList(Index).name;    
    [~, name, ] = fileparts(baseFileName);
    ListOfImageVideos{Index} = name;
end
set(handles.popup_video,'string',ListOfImageVideos);
handles.selectedVideo = ListOfImageVideos{1};

% Others
handles.activityFFT = true;
handles.selectedROI = [1 1; 1 1];
handles.spectrum_stat_type = 'Average Spectrum (whole image)';
handles.lq = 0.25;
handles.hq = 0.75;

% Update handles structure
guidata(hObject, handles);
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
handles.selectedVideo = [contents{get(hObject,'Value')} '.mat'];
updateAll(hObject, handles)

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
updateAll(hObject, handles)

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
handles.selectedROI = ceil(get(gca,'currentpoint'));
updateAll(hObject, handles);

% --- Executes during object creation, after setting all properties.
function activity_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to activity_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate activity_plot

function updateAll(hObject, handles)
currentDataPath = [handles.resultsFolder handles.ROISize '/' ...
    handles.selectedVideo];
data = load(currentDataPath);

% Activity
axes(handles.activity_plot);
if handles.activityFFT
    generateActivityImage( fftPowerActivity(data.fftPower), 'Activity: FFT-Power' );
else
    generateActivityImage( data.activity, 'Activity: Entropy' );
end
set(gcf,'WindowButtonDownFcn',@(hObject,eventdata)gui('activity_plot_ButtonDownFcn',hObject,eventdata,guidata(hObject)))
hold on
plot(handles.selectedROI(1,1), handles.selectedROI(1,2),'r.','MarkerSize',20)
hold off

% The mask
axes(handles.mask);
mask = activityMask( data.activity, handles.lq, handles.hq );
generateActivityImage( mask, 'Activity Mask' );

% Average or max spectrum over mask
axes(handles.spectrum_stat);
switch handles.spectrum_stat_type
    case 'Average Spectrum (whole image)'
        meanPower = mean(mean(data.fftPower,2),3);
        spectrumPlot( meanPower, data.freqs, 'Average CBF Spectrum' )
    case 'Average Spectrum (mask)'
        maskedPower = data.fftPower(:,mask);
        meanPower = mean(maskedPower,2);
        spectrumPlot( meanPower, data.freqs, 'Average CBF Spectrum (Masked)' )
    case 'Maximum Spectrum (whole image)'
        [~, idx] = max(data.activity(:));
        [row,col] = ind2sub([size(data.fftPower,2), size(data.fftPower,3)], idx);
        spectrumPlot( data.fftPower(:,row,col), data.freqs, 'Max Activity Spectrum' )
    case 'Maximum Spectrum (mask)'
        [~, idx] = max(data.activity(:).*mask(:));
        [row,col] = ind2sub([size(data.fftPower,2), size(data.fftPower,3)], idx);
        spectrumPlot( data.fftPower(:,row,col), data.freqs, 'Max Activity Spectrum (Masked)' )
    case 'Frequency Image'
        dominantFrequencyImage( data.dominantFreqs, 'Dominant Frequencies per ROI' );
end   

% Distrivution of dominant frequencies
axes(handles.histogram);
maskedFreqs = data.dominantFreqs(mask);
histogram(maskedFreqs(maskedFreqs<46),100);
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Dominant Frequencies per ROI (Masked)}')

% Selected ROI
axes(handles.spectrum_selected);
try
    spectrumPlot( data.fftPower(:,handles.selectedROI(1,1),... 
        handles.selectedROI(1,2)), data.freqs, 'Selected Spectrum' )
catch
    
end

guidata(hObject, handles);
