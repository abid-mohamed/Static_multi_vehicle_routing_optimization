function vh=afct_vh(cc,cc_dmd,cc_t,vh,dc0)
vh_tst=vh; l=0;
[nl,nc]=size(vh_tst.ncptd);
for i=1:nl
    if (vh_tst.ncptd(i,6)==0)
        if cc_dmd < vh_tst.ncptd(i,2)
            l=l+1; dc_vh(l,1)=vh_tst.ncptd(i,1);
            dc_vh(l,2)=dc0(cc+1,vh_tst.ncptd(i,3)+1);
        else
            l=l+1; dc_vh(l,1)=vh_tst.ncptd(i,1);
            dc_vh(l,2)=dc0(cc+1,1)+dc0(1,vh_tst.ncptd(i,3)+1);
        end
    end
end
dc_vh=sortrows(dc_vh,2);v=dc_vh(1,1);
vh.ncptd(v,2)=vh.ncptd(v,2)-cc_dmd;
vh.ncptd(v,3)=cc;
vh.ncptd(v,4)=vh.ncptd(v,4)+cc_t;
vh.ncptd(v,5)=vh.ncptd(v,5)+dc_vh(1,2);
vh.ncptd(v,6)=1;
l=size(vh.pchst{v},1);
vh.pchst{v}(l+1,1)=vh.ncptd(v,3);
vh.pchst{v}(l+1,2)=vh.ncptd(v,2);
vh.pchst{v}(l+1,3)=vh.ncptd(v,4);
vh.pchst{v}(l+1,4)=vh.ncptd(v,5);
clear vh_tst dc_vh;