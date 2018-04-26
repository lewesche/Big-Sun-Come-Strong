%Leif Wesche
%BSCS Background

function [C] = BSCS_Background(s, t0, trgb, ind, t, dt)


        map=[];
        for i=logspace(0, 1.5, 100)
            temp=[abs(sin(t/trgb)), 0, abs(cos(t/trgb))]/i;
            map=[temp; map];
        end
        if round(mod(t,t0), 1) == 0
            tc=0;
        end
        tc=tc+dt;
        for i=1:length(ind)
            C(ind(1,i), ind(2,i))=(0.4*cos(tc/(t0/2)*pi+ind(3,i))+0.6);
            if C(ind(1,i), ind(2,i)) < 0.25
                C(ind(1,i), ind(2,i))=0;
                ind(1:end-1,i)=randi([1, 82], 2, 1);
            end
        end

end