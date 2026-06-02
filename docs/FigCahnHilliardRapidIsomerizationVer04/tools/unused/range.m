function phi = range(phi,phi0,verbose)
alow = find(phi<0);
if alow
    phi(alow)=-phi(alow); % reflect around 0
    if verbose
        disp(['Moved ' inputname(1) '<0 back in range for ' num2str(length(alow)) ' elements.' ])
        disp(sprintf('%d: %2.6f\n',[ alow phi(alow) ]'));
    end
end
ahigh = find(phi>1);
if ahigh
    phi(ahigh)=2-phi(ahigh); % reflect around 1
    if verbose
        disp(['Moved ' inputname(1) '>1 back in range for ' num2str(length(ahigh)) ' elements.' ])
        disp(sprintf('%d: %2.6f\n',[ ahigh phi(ahigh) ]'));
    end
end
if length(alow) + length(ahigh)
    if phi0 ~= 0
        phi = phi*phi0/mean(phi,'all');
    end
end
end
 