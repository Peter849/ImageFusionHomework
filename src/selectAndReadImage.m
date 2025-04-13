function img = selectAndReadImage()
    [filename, pathname] = uigetfile('*.*', 'Please select an image for image fusion!');
    
    if isequal(filename, 0) || isequal(pathname, 0)
        error('No file selected.');
    end
    
    filewithpath = fullfile(pathname, filename);
    img = imread(filewithpath);
end
