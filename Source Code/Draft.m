function []=Draft(layer,p,aux)
% draw the crease pattern

global n a b d k sita FID FID_M FID_V

% axis equal;
% k=length(sita)-1; % add one more facet by sita, change sita in origami_generator
dxf=aux(3);

facet1=Rotate_Matrix(1,p)*basic_facet(1);%basic_facet(1);
facet2=facet1(1:3,:);
h_layer=abs(facet1(1,2));%半层高度

for j=1:1:layer
    facet2(1,:)=facet1(1,:)+(j*2-1)*h_layer;
    Lineframe(facet2,(j*2-1)*h_layer,layer-j,dxf);
end

for i=3:2:k 
   facet=Rotate_Matrix(i,p)*basic_facet(i);
   facet2=facet;
%    h_layer=abs(facet(1,2));
   if((sita(i)-90)*(sita(i+1)-90)>0)    %相邻角差大于90度说明折痕会相同
       if(sita(i)<90)
           for j=1:1:layer
                facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;
                Lineframe(facet2,(j*2-1)*h_layer,layer-j,dxf);
           end
       else                          %在经过大于90度的折痕后会发生折痕相反的规律变化
           for j=1:1:layer
                facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;
                Lineframe_inverse(facet2,(j*2-1)*h_layer,layer-j,dxf);
           end
       end       
   else
       if(sita(i)<90)
           for j=1:1:layer
                facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;
                Lineframe_same(facet2,(j*2-1)*h_layer,layer-j,dxf);
           end   
       else
           for j=1:1:layer
                facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;
                Lineframe_same_b(facet2,(j*2-1)*h_layer,layer-j,dxf);
           end 
       end   
    end
end

for i=2:2:k                            %补齐中间偶数位置的折痕，只需要补画上下两条线
   facet=Rotate_Matrix(i,p)*basic_facet(i);
   facet2=facet;
%    h_layer=abs(facet(1,2));
   for j=1:1:layer
        facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;
        Lineframe_odd(facet2,(j*2-1)*h_layer,layer-j,dxf);
   end
end

% 当sita在末尾多加一个值时候不需要下面去补充最右侧线，只存在规则形状中，在主程序中修改
for j=1:1:layer
   facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;

   plot3([facet2(1,4),facet2(1,3)],[facet2(2,4),facet2(2,3)],[facet2(3,4),facet2(3,3)],'r','Linewidth',1);hold on;
   plot3(2*(j*2-1)*h_layer-[facet2(1,4),facet2(1,3)],[facet2(2,4),facet2(2,3)],[facet2(3,4),facet2(3,3)],'r','Linewidth',1);hold on;
   
   %% 写入dxf文件
    if dxf==1
        dxf_polyline(FID_M,[facet2(1,4);facet2(1,3)],[facet2(2,4);facet2(2,3)],[facet2(3,4);facet2(3,3)]);
        dxf_polyline(FID_M,2*(j*2-1)*h_layer-[facet2(1,4);facet2(1,3)],[facet2(2,4);facet2(2,3)],[facet2(3,4);facet2(3,3)]);
        
    end
   
end

axis equal; rotate3d on;
% axis off;
xlabel('x(mm)','FontAngle','italic');ylabel('y(mm)','FontAngle','italic');zlabel('z(mm)','FontAngle','italic');
set(gca,'FontName','Gill Sans MT','Fontsize',10);
title('Origami pattern','Fontsize',12);
% set(gca,'color',[242,242,242]/255);
% set(gcf,'color','none');
%% 绘制位于每个顶点处的圆孔
if aux(1)~=0 || aux(2)~=0 || aux(4)~=0
    % 计算出所有顶点的坐标,坐标已平移到x正半轴
    for i=1:2:k
        facet=Rotate_Matrix(i,p)*basic_facet(i);
        for j=1:1:layer
            % 存入三维数组
            H_layer=(2*j-1)*h_layer;
            facet3(i,2*j-1,1:3)=[H_layer+facet(1,2),facet(2,2),facet(3,2)];
            facet3(i,2*j,1:3)=[H_layer+facet(1,1),facet(2,1),facet(3,1)];
            facet3(i+1,2*j-1,1:3)=[H_layer+facet(1,3),facet(2,3),facet(3,3)];
            facet3(i+1,2*j,1:3)=[H_layer+facet(1,4),facet(2,4),facet(3,4)];
        end
        facet3(i,2*j+1,1:3)=[(2*j+1)*h_layer+facet(1,2),facet(2,2),facet(3,2)];
        facet3(i+1,2*j+1,1:3)=[(2*j+1)*h_layer+facet(1,3),facet(2,3),facet(3,3)];
    end

    i=i+2; %i为倒数第1个点,加2后为最后一个点
    facet=Rotate_Matrix(i-1,p)*basic_facet(i-1);
    for j=1:1:layer
        % 存入三维数组
        H_layer=(2*j-1)*h_layer;
        facet3(i,2*j-1,1:3)=[H_layer+facet(1,3),facet(2,3),facet(3,3)];
        facet3(i,2*j,1:3)=[H_layer+facet(1,4),facet(2,4),facet(3,4)];
    end
    facet3(i,2*j+1,1:3)=[(2*j+1)*h_layer+facet(1,3),facet(2,3),facet(3,3)];   
%     save facet3.mat facet3

    %注意三角形时由于sita添加了一个值，i需要减一达到最后一个点
    if n==3
        i=i-1;  
    end

    %计算外围的切割线
    Cut_origin(1:3)=facet3(1,1,1:3);
    Cut_left(:,1)=facet3(1,:,1);Cut_left(:,2)=facet3(1,:,2);Cut_left(:,3)=facet3(1,:,3);
    Cut_right(:,1)=facet3(i,:,1);Cut_right(:,2)=facet3(i,:,2);Cut_right(:,3)=facet3(i,:,3);
    if aux(4)==0
        Cut_right_f=[flipud(Cut_right(:,1)),flipud(Cut_right(:,2)),flipud(Cut_right(:,3))]; %调整顺序从最上面到最下面
        Cut_line=[Cut_left;Cut_right_f;Cut_origin];%构建闭环外围线
        plot3(Cut_line(:,1),Cut_line(:,2),Cut_line(:,3),'-k'); hold on;
        if dxf == 1
            dxf_polyline(FID,Cut_line(:,1),Cut_line(:,2),Cut_line(:,3));
        end
    end
end

%% 画出卡扣
if aux(4)>0
    % 计算卡扣的顶点坐标
    x0=facet3(1,1,1); y0=facet3(1,1,2); 
    x0_end=facet3(i,1,1); y0_end=facet3(i,1,2);

    D_1=b(1)/1.5; D_2=d(1)/4; %确定起点位置
    D_L=d(1)/4; D_W=d(1)/10; %确定方框大小
    D_slope=sita(1);

    % 计算特殊情况下的卡扣形状
    if n==4 || n==3
        D_1=b(1)/3;
    end
    if b(1)<D_W  %当n>4, L=2W
        D_1=a(1)/6; D_2=d(1)/6; %确定起点位置
        D_L=d(1)/4; D_W=d(1)/10; %确定方框大小
        D_slope=(sita(1));
    end

    %卡扣最左侧方框
    y1=y0+D_1-D_2*cosd(D_slope); x1=x0+D_2*sind(D_slope);
    y2=y1+D_W*sind(D_slope); x2=x1+D_W*cosd(D_slope);
    y3=y2-D_L*cosd(D_slope); x3=x2+D_L*sind(D_slope);
    y4=y1-D_L*cosd(D_slope); x4=x1+D_L*sind(D_slope); 
    Rec0=[x1 y1 0; x2 y2 0; x3 y3 0; x4 y4 0; x1 y1 0];
    for j=1:1:layer
        Rec1=[2*h_layer*(j-1)+Rec0(:,1),Rec0(:,2),Rec0(:,3)];
        Rec2=[2*h_layer*j-Rec0(:,1),Rec0(:,2),Rec0(:,3)];
        plot3(Rec1(:,1),Rec1(:,2),Rec1(:,3),'-k'); hold on;
        plot3(Rec2(:,1),Rec2(:,2),Rec2(:,3),'-k'); hold on;
        if dxf == 1
            dxf_polyline(FID,Rec1(:,1),Rec1(:,2),Rec1(:,3));
            dxf_polyline(FID,Rec2(:,1),Rec2(:,2),Rec2(:,3));
        end
    end

    %卡扣最右侧凸起
    
    if sita(i)>90 || n==3  %特殊情况处理
        D_slope=180-sita(1);
    end
    D_W1=D_W*1.2;
    y1_end=y0_end+D_1; x1_end=x0_end;
    y2_end=y1_end-D_2*cosd(D_slope);  x2_end=x1_end+D_2*sind(D_slope);
    y3_end=y2_end+D_W/2*sind(D_slope); x3_end=x2_end+D_W/2*cosd(D_slope);
    y4_end=y3_end+D_W1*cosd(D_slope); x4_end=x3_end-D_W1*sind(D_slope);
    y5_end=y4_end+D_W1*sind(D_slope); x5_end=x4_end+D_W1*cosd(D_slope);
    y6_end=y5_end-(2*D_W1+D_L)*cosd(D_slope);  x6_end=x5_end+(2*D_W1+D_L)*sind(D_slope);
    y7_end=y6_end-D_W1*sind(D_slope); x7_end=x6_end-D_W1*cosd(D_slope);
    y8_end=y7_end+D_W1*cosd(D_slope); x8_end=x7_end-D_W1*sind(D_slope);
    y9_end=y8_end-D_W/2*sind(D_slope); x9_end=x8_end-D_W/2*cosd(D_slope);

    D_S=h_layer-(x9_end-x1_end);
    y10_end=y9_end-D_S/tand(D_slope); x10_end=x9_end+D_S;
    
    Convex0=[x1_end y1_end 0; x2_end y2_end 0; x3_end y3_end 0; x4_end y4_end 0; x5_end y5_end 0; x6_end y6_end 0; x7_end y7_end 0; x8_end y8_end 0; x9_end y9_end 0; x10_end y10_end 0];
    Convex2=[2*h_layer-flipud(Convex0(1:9,1)),flipud(Convex0(1:9,2)),flipud(Convex0(1:9,3))]; % 对称后需要翻转顺序从下到上
    Cut_right=[Convex0;Convex2];
    plot3([facet3(i,1,1),Convex0(1,1)],[facet3(i,1,2),Convex0(1,2)],[facet3(i,1,3),Convex0(1,3)],'r','Linewidth',1);hold on;
    plot3([facet3(i,2,1),Convex0(10,1)],[facet3(i,2,2),Convex0(10,2)],[facet3(i,2,3),Convex0(10,3)],'b-.','Linewidth',1);hold on;
    plot3([facet3(i,3,1),Convex2(9,1)],[facet3(i,3,2),Convex2(9,2)],[facet3(i,3,3),Convex2(9,3)],'r','Linewidth',1);hold on; 
    if dxf == 1
        dxf_polyline(FID_M,[facet3(i,1,1);Convex0(1,1)],[facet3(i,1,2);Convex0(1,2)],[facet3(i,1,3);Convex0(1,3)]);
        dxf_polyline(FID_M,[facet3(i,3,1);Convex2(9,1)],[facet3(i,3,2);Convex2(9,2)],[facet3(i,3,3);Convex2(9,3)]);
        dxf_polyline(FID_V,[facet3(i,2,1);Convex0(10,1)],[facet3(i,2,2);Convex0(10,2)],[facet3(i,2,3);Convex0(10,3)]);    
    end
    for j=2:1:layer
        Convex1=[2*h_layer*(j-1)+Convex0(:,1),Convex0(:,2),Convex0(:,3)];    
        Convex2=[2*h_layer*j-flipud(Convex0(1:9,1)),flipud(Convex0(1:9,2)),flipud(Convex0(1:9,3))];   
        Cut_right=[Cut_right;Convex1;Convex2];
        plot3([facet3(i,2*j,1),Convex1(10,1)],[facet3(i,2*j,2),Convex1(10,2)],[facet3(i,2*j,3),Convex1(10,3)],'b-.','Linewidth',1);hold on;
        plot3([facet3(i,2*j+1,1),Convex2(9,1)],[facet3(i,2*j+1,2),Convex2(9,2)],[facet3(i,2*j+1,3),Convex2(9,3)],'r','Linewidth',1);hold on;
        if dxf == 1
            dxf_polyline(FID_M,[facet3(i,2*j+1,1);Convex2(9,1)],[facet3(i,2*j+1,2);Convex2(9,2)],[facet3(i,2*j+1,3);Convex2(9,3)]);
            dxf_polyline(FID_V,[facet3(i,2*j,1);Convex1(10,1)],[facet3(i,2*j,2);Convex1(10,2)],[facet3(i,2*j,3);Convex1(10,3)]);    
        end
    end
    % 画出外围辅助框线
    Cut_right_f=[flipud(Cut_right(:,1)),flipud(Cut_right(:,2)),flipud(Cut_right(:,3))]; %调整顺序从最上面到最下面
    Cut_line=[Cut_left;Cut_right_f;Cut_origin];%构建闭环外围线
    plot3(Cut_line(:,1),Cut_line(:,2),Cut_line(:,3),'-k'); hold on;
    if dxf == 1
        dxf_polyline(FID,Cut_line(:,1),Cut_line(:,2),Cut_line(:,3));
    end
end

%% 画出圆孔，排除四周顶点
if aux(1)>0
    %当添加卡扣时最末端也需要打孔
    if aux(4)==0
        Max_i=i-1;
    else
        Max_i=i;
    end

    for index_i=2:1:Max_i %利用之前的循环数i和j指示末端位置
        for index_j=2:1:2*layer
            %draw auxiliary circle
            Center(1)=facet3(index_i,index_j,1);
            Center(2)=facet3(index_i,index_j,2); % aux(1)是直径
            rectangle('Position',[Center-aux(1)/2,aux(1),aux(1)],'Curvature',[1,1],'EdgeColor','k','linewidth',0.6);hold on;
        end
    end
    % 输出到dxf文件
    if dxf == 1
        % 画出圆孔，排除四周顶点
        for index_i=2:1:Max_i %利用之前的循环数i和j指示末端位置
            for index_j=2:1:2*layer
                dxf_circle(FID,facet3(index_i,index_j,:),0.5); %圆孔半径0.5mm
            end
        end
    end

end
%% 画出辅助线
if aux(2)>0

    % 表示出四个最边缘顶点x，y坐标，并在此基础上外扩10mm作辅助线
    Min_y=min(facet3(1,:,2))-aux(2); Max_y=max(facet3(i,:,2))+aux(2);
    Min_x=min(facet3(:,1,1))-aux(2); Max_x=max(facet3(:,2*layer+1,1))+aux(2);
    if aux(4)>0
        Max_y=y5_end+aux(2);
    end
    %     Min_z=0; Max_z=0; %折纸图案位于x-y平面，z始终为0
    aux_line=[[Min_x,Min_y,0];
        [Max_x,Min_y,0];
        [Max_x,Max_y,0];
        [Min_x,Max_y,0];
        [Min_x,Min_y,0]];
    %     save facet3.mat facet3

    rectangle('Position',[Min_x,Min_y,Max_x-Min_x,Max_y-Min_y],'EdgeColor','k','linewidth',1); hold on;

    if dxf == 1
        dxf_polyline(FID,aux_line(:,1),aux_line(:,2),aux_line(:,3));
        dxf_polyline(FID_M,aux_line(:,1),aux_line(:,2),aux_line(:,3));
        dxf_polyline(FID_V,aux_line(:,1),aux_line(:,2),aux_line(:,3));
    end
end

end

