clear; clc;
recObj = audiorecorder(44100,16,1);
disp('Start speaking.')
recordblocking(recObj, 4);
disp('End of Recording.');
y = getaudiodata(recObj);
%plot(y);
[h,w] = freqz(y);
plot(w,abs(h));
[a b] = max(abs(h));

play(recObj);
%http://www.mathworks.com/help/matlab/import_export/record-and-play-audio.html
test = myfun(signal,1);