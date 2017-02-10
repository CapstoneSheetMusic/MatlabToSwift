function y = PrintMusicNote(charvar)

    % Function PrintMusicNote is used to neatly print the note calcualted
    % by DetectNote and corresponding to the list of pitch names. The
    % structure of the funciton is quite self explanitory
    
    fprintf('The note is: ');
    if(charvar(1) == 'c')
        fprintf('C ');
    elseif (charvar(1) == 'd')
        fprintf('D ');
    elseif (charvar(1) == 'e')
        fprintf('E ');
    elseif (charvar(1) == 'f')
        fprintf('F ');
    elseif (charvar(1) == 'g')
        fprintf('G ');
    elseif (charvar(1) == 'a')
        fprintf('A ');
    else 
        fprintf('B ');
    end
        
    if (charvar(2) == 's')
        fprintf('sharp\n');
    else
        fprintf('natural\n');
    end
        
    y = 1;



end