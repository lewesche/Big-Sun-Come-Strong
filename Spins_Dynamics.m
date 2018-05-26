%Leif Wesche
%BSCS Dynamics

function [x, v] = BSCS_Dynamics(x, v, dt, M, x0) 
    D=size(x); D=D(1);
    Particles=length(x);
    
    for n=1:Particles
        for d=[1:D]
            r(d,n)=[x(d,n)-x0(d)];
        end
        a(:,n)=M/(norm(r(:,n))^2).*(-r(:,n));
    end
    for n=1:Particles
        if norm(r(:,n))<=0.25;
            a(:,n)=[0;0];
            %vxy(:,n)=real(vxy(:,n).^0.1);
        end
    end
    v=v+a.*dt;
    x=x+v.*dt;
    
    
end