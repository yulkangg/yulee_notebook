function val = mylog(x)
val = real(log(x)); val(find(x==0))=log(eps);
end
 