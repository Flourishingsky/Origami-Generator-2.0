function f=Surf_write(fid,X,Y,Z)
for i=1:size(Z,1)-1
    for j=1:size(Z,2)-1
 
        %splitting each small rectangular to 2 small triangular
        p1=[X(i,j),Y(i,j),Z(i,j)];
        p2=[X(i+1,j),Y(i+1,j),Z(i+1,j)];
        p3=[X(i+1,j+1),Y(i+1,j+1),Z(i+1,j+1)];
    local_write_facet(fid,p1,p2,p3);
 
        p1=[X(i,j),Y(i,j),Z(i,j)];
        p3=[X(i,j+1),Y(i,j+1),Z(i,j+1)];
        p2=[X(i+1,j+1),Y(i+1,j+1),Z(i+1,j+1)];
    local_write_facet(fid,p1,p2,p3);
    end
end
f=1;
end
 
 
%to write a single small triangular to the file
function num = local_write_facet(fid,p1,p2,p3)
    num = 1;
    n = local_find_normal(p1,p2,p3);
 
        fprintf(fid,'facet normal %.7E %.7E %.7E\r\n', n(1),n(2),n(3) );
        fprintf(fid,'outer loop\r\n');
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p1);
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p2);
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p3);
        fprintf(fid,'endloop\r\n');
        fprintf(fid,'endfacet\r\n');
 
end
 
%to generate the normal direction vector n, from the vertex of triangular
function n = local_find_normal(p1,p2,p3)

v2 = p2-p1;
v1 = p3-p1;
v3 = cross(v1,v2);
n = v3 ./ sqrt(sum(v3.*v3));

end