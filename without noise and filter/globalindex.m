function GI=globalindex(Pco,IMP,Pnd,Pfa)
Pc=(1-Pco)*(1-Pco);
IM=(1-IMP)*(1-IMP);
Pn=Pnd*Pnd;
Pf=Pfa*Pfa;
GI=sqrt(Pc+IM+Pn+Pf);
