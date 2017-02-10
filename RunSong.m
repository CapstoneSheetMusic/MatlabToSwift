function y = RunSong(charvar)
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
    elseif(charvar(2) == 'f');
        fprintf('flat\n');
    else
        fprintf('\n');
        
    y = 1;



end