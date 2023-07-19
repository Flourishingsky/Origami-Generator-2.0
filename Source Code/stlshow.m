function stlshow(file)

% 打开STL文件
fid = fopen(file,'rt');
% 初始化数据矩阵
vertices = [];
faces = [];
normal = [];
% 读取STL文件头部
hdr = fgetl(fid);
% disp(['STL文件头部: ' hdr]);
 
% 循环读取三角形面
while (~feof(fid))
    tmp = fgetl(fid);
    if strfind(tmp,'normal') ~= 0
        normal = [normal;sscanf(tmp,'%*s %*s %f %f %f')'];
    elseif strfind(tmp,'vertex') ~= 0
        vertices = [vertices; sscanf(tmp,'%*s %f %f %f')'];
    elseif strncmpi(tmp,'endsolid',8) == 1
%         disp('over')
        break;
    end
end
% 关闭文件
fclose(fid);
% 输出结果
% disp(['顶点数: ' num2str(size(vertices,1))]);
% 
% fig = figure;
% ax = axes('Parent',fig);
% 
% X_min_max=get(gca,'Xlim');
% Y_min_max=get(gca,'Ylim');
% Z_min_max=get(gca,'Zlim');
% [AZ,EL] = view;
for i = 1:size(vertices,1)/3
    v1 = vertices((i -1)*3+1,:);
    v2 = vertices((i -1)*3+2,:);
    v3 = vertices((i -1)*3+3,:);
    n = normal(i,:);
    patch([v1(1) v2(1) v3(1)], [v1(2) v2(2) v3(2)], [v1(3) v2(3) v3(3)], 'y', 'FaceAlpha', 0.5, 'EdgeColor', 'black', 'FaceNormals', n);
end
% 设置坐标轴和视角
axis equal;
% xlim(X_min_max);ylim(Y_min_max);zlim(Z_min_max);
% view(AZ,EL);
axis tight;
% set(gcf, 'WindowStyle', 'modal');
view(3);
end