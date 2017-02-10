%% Take 2
clear; clc;

prompt1 = 'How many notes will you sing? ';
prompt2 = 'What is the duration of each note (sec)? ';

Num_notes = input(prompt1);
Duration_notes = input(prompt2);

time = Num_notes*Duration_notes;

recObj = audiorecorder(44100,16,1);
disp('Start speaking.')
recordblocking(recObj, time);
disp('End of Recording.');

y_raw = getaudiodata(recObj);
b = .05.*[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

y = filter(b,1,y_raw);

test = 1:size(y,1);


Y(:,1) = y(1:size(y)/Num_notes);

if (Num_notes > 1)
    
    for i = 2:Num_notes;
        Y(:,i) = y((i-1)*size(y)/Num_notes + 1:i*size(y)/Num_notes);
    end
end



N = size(y,1)/Num_notes;
H(:,1) = fft(y(1:N));
[A(:,1) B(:,1)] = max(abs(H(:,1)));
fprintf('%f\n',B(:,1));

if Num_notes > 1
    for i = 2:Num_notes;
        H(:,i) = fft(y((i-1)*N +1 :i*N));
        [A(:,i) B(:,i)] = max(abs(H(:,i)));
        fprintf('%f\n',B(:,i));
    end
end



Name_ref = ['cn';'cs';'dn';'ds';
            'en';'fn';'fs';'gn';
            'gs';'an';'as';'bn';
            'cn';'cs';'dn';'ds';
            'en';'fn';'fs';'gn';
            'gs';'an';'as';'bn';
            'cn';'cs';'dn';'ds';
            'en';'fn';'fs';'gn';
            'gs';'an';'as';'bn';
            'cn';'cs';'dn';'ds';
            'en';'fn';'fs';'gn';
            'gs';'an';'as';'bn';
            'cn';'cs';'dn';'ds';
            'en';'fn';'fs';'gn';
            'gs';'an';'as';'bn'; 'cn'];
        
Note_ref = [65.41 69.3	73.42	77.78	82.41	87.31	92.5	98	103.83...
    110	116.54	123.47	130.81	138.59	146.83	155.56	164.81	174.61	...
    185	196	207.65	220	233.08	246.94	261.63	277.18	293.66	311.13	...
    329.63	349.23	369.99	392	415.3	440	466.16	493.88	523.25	554.37...
    587.33	622.25	659.25	698.46	739.99	783.99	830.61	880	932.33	...
    987.77	1046.5	1108.73	1174.66	1244.51	1318.51	1396.91	1479.98... 
    1567.98	1661.22	1760	1864.66	1975.53	2093];


        
    

for i = 1:Num_notes
    [I(:,i) J(:,i)] = min(abs(Note_ref - B(:,i)));
    RunSong(Name_ref(J(:,i),:));
end