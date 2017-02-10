function output = DetectNote(varargin)

    % Function DetectNote is used to determine the musical notes 
    % corresponding with a given input audio file or a live recording. It
    % takes arguments in the following form
    % 
    % output = DetectNote() returns the average error in 'output'. The
    % audio file read is a live recording. That is, The function asks the
    % user to input the parameters such as number of notes and duration of
    % each note. The sampling rate is assumed to be 44100
    % 
    % output = DetectNote(fs) returns the average error in 'output'. The
    % audio file read is a live recording, but unlike the previous example,
    % the user can specify the sampling frequency fs
    %
    % In both above cases, the low pass filter is automatically applied
    %
    % DetectNote funciton can also handle prerecorded audio inputs. Any
    % prerecorded file must have three parameters formatted as followed
    %
    % output = DetectNote(inputFile, NumberOfNotes, FilterFlag) returns the
    % average error. The first parameter must be the input audio matrix.
    % The second parameter must be the number of notes that the input
    % contains. The final input is a flag that, if 0, will use the low pass
    % filter. Any other value here will result in not using the Low pass
    % filter
    % 
    % This code was written for Professor Bajwa's Digital Signal Processing 
    % class for Spring 2016. It was written by Harshat Kumar, Mantav Dalal,
    % and Prerak Mehta. For any further questions, please do not hesitate
    % to email dmantav@gmail.com
    
    tic

    errormsg = 'Incorrect Number of arguments! ''Use help DetectNote'' for instructions';
    % Makes sure the number of arguments are correct
    if ~(nargin ==3 || nargin ==1 || nargin == 0)
        error(errormsg);
    end
    
    
    filterflag = false;
    if nargin == 3
        % gets the info from input parameters (prerecorded audio)
        y_raw = varargin{1};
        Num_notes = varargin{2};
        dontusefilter = varargin{3};
        fs = 44100;
    else
        % Live recording sample frequency selection
        if nargin == 0
            fs = 44100;
        else
            fs = varargin{1};
        end
        prompt1 = 'How many notes will you sing? ';
        prompt1a = 'CHOOSE\nPress (1) to enter notes by Duration\nPress (2) to enter by bmp\n';
        prompt2 = 'What is the duration of each note (sec)? ';
        prompt2a = 'What is the tempo you will be singing (bpm)?';
        Num_notes = input(prompt1);
        tempoFlag = input(prompt1a);
        
        while (tempoFlag ~= 1 && tempoFlag ~= 2)
            fprintf('Please input a valid response\n');
            tempoFlag = input(prompt1a);
        end

        if (tempoFlag == 1)
            Duration_notes = input(prompt2);
        else
            bmp = input(prompt2a);
            Duration_notes = 60./bmp;
        end
        
        time = Num_notes*Duration_notes;
        dontusefilter = 0;
        recObj = audiorecorder(fs,16,1);
        %Prompts to start and stop s
        disp('Start singing!')
        recordblocking(recObj, time);
        disp('End of Recording... Time to calculate!');

        y_raw = getaudiodata(recObj);
    end
    
    if (dontusefilter == 0)
        fprintf('A low pass filter will be used\n');
        % Low pass filter created using windowing method
        filterflag = true;
        Nf = 883;
        M = (Nf - 1)/2;
        n = 0:Nf-1;
        lpf = sinc(80*pi.*(n-M)./441);
        y = filter(lpf,1,y_raw);
        
        % Create plot of impulse and freq response
        figure;
        plot(n,abs(lpf));
        title('Impulse response of low pass filter');
        xlabel('n');
        ylabel('h[n]');
        grid on;
        
        freqz(lpf);
        
    else
        y = y_raw;
    end
    
    % Create plot to show the audio signal
    t = 0:size(y,1)-1;
    figure; 
    plot(t./fs,y);
    xlabel('t');
    if filterflag
        title('Input signal after LPF');
    else
        title('Input signal');
    end
    grid on;
    
    % Divide input signal into N sections where N is the number of notes
    N = size(y,1)/Num_notes;
    % Take the fft of the notes to determine the dominant frequency (pitch)
    H(:,1) = fft(y(1:N));
    % Find the dominant frequency
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

    Note_ref = [65.41 69.3    73.42    77.78    82.41    87.31    92.5    98    103.83...
        110    116.54    123.47    130.81    138.59    146.83    155.56    164.81    174.61    ...
        185    196    207.65    220    233.08    246.94    261.63    277.18    293.66    311.13    ...
        329.63    349.23    369.99    392    415.3    440    466.16    493.88    523.25    554.37...
        587.33    622.25    659.25    698.46    739.99    783.99    830.61    880    932.33    ...
        987.77    1046.5    1108.73    1174.66    1244.51    1318.51    1396.91    1479.98... 
        1567.98    1661.22    1760    1864.66    1975.53    2093];

    % Now we compare the values of the freqencies with the table above. The
    % closest freqency to the given table is most likely the pitch of
    % concern. Therefore we find the note that corresponds to that
    % frequency. The table was obtained from the values given from
    % http://www.phy.mtu.edu/~suits/notefreqs.html
    
    for i = 1:Num_notes
        [I(:,i) J(:,i)] = min(abs(Note_ref - B(:,i)));
        PrintMusicNote(Name_ref(J(:,i),:));
    end
    % output is the average error between the calculated notes and the
    % table value to which the pitch is the closest
    output = [sum(abs(I))/Num_notes,toc];

end