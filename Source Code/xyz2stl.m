function xyz2stl(file,layer)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
global AA BB

% set(gcf, 'WindowStyle', 'modal');
H=abs(AA(1,2));

fid=fopen(file,'w');
fprintf(fid,'solid\n');
    %other surface assumed to be plane
    for i=1:1:length(AA(1,:))-1
        for j=1:1:layer
            x1=[(2*j-1)*H+AA(1,i),(2*j-1)*H+BB(1,i);(2*j-1)*H+AA(1,i+1),(2*j-1)*H+BB(1,i+1)];
            x_1=[(2*j-1)*H-AA(1,i),(2*j-1)*H-BB(1,i);(2*j-1)*H-AA(1,i+1),(2*j-1)*H-BB(1,i+1)];
            y1=[AA(2,i),BB(2,i);AA(2,i+1),BB(2,i+1)];
            z1=[AA(3,i),BB(3,i);AA(3,i+1),BB(3,i+1)];
            Surf_write(fid,x1,y1,z1);
            Surf_write(fid,x_1,y1,z1);
        end
    end
 
    fprintf(fid,'endsolid');
    fclose(fid);
 
end