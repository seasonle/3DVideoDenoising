function saveRes(homepath, name, res)
    formatOut = 'yy-mm-dd_HH_MM_SS';
    save(fullfile(homepath,"results\",strcat(name,datestr(now,formatOut),".mat")),'res');
    clear(name);
end