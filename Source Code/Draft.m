function []=Draft(layer,p,aux)
% draw the crease pattern

global n a b d k sita FID FID_M FID_V

% axis equal;
% k=length(sita)-1; % add one more facet by sita, change sita in origami_generator
dxf=aux(3);

facet1=Rotate_Matrix(1,p)*basic_facet(1);%basic_facet(1);
facet2=facet1(1:3,:);
h_layer=abs(facet1(1,2));%���߶�

for j=1:1:layer
    facet2(1,:)=facet1(1,:)+(j*2-1)*h_layer;
    Lineframe(facet2,(j*2-1)*h_layer,layer-j,dxf);
end

for i=3:2:k 
   facet=Rotate_Matrix(i,p)*basic_facet(i);
   facet2=facet;
%    h_layer=abs(facet(1,2));
   if((sita(i)-90)*(sita(i+1)-90)>0)    %���ڽǲ����90��˵���ۺۻ���ͬ
       if(sita(i)<90)
           for j=1:1:layer
                facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;
                Lineframe(facet2,(j*2-1)*h_layer,layer-j,dxf);
           end
       else                          %�ھ�������90�ȵ��ۺۺ�ᷢ���ۺ��෴�Ĺ��ɱ仯
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

for i=2:2:k                            %�����м�ż��λ�õ��ۺۣ�ֻ��Ҫ��������������
   facet=Rotate_Matrix(i,p)*basic_facet(i);
   facet2=facet;
%    h_layer=abs(facet(1,2));
   for j=1:1:layer
        facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;
        Lineframe_odd(facet2,(j*2-1)*h_layer,layer-j,dxf);
   end
end

% ��sita��ĩβ���һ��ֵʱ����Ҫ����ȥ�������Ҳ��ߣ�ֻ���ڹ�����״�У������������޸�
for j=1:1:layer
   facet2(1,:)=facet(1,:)+(j*2-1)*h_layer;

   plot3([facet2(1,4),facet2(1,3)],[facet2(2,4),facet2(2,3)],[facet2(3,4),facet2(3,3)],'r','Linewidth',1);hold on;
   plot3(2*(j*2-1)*h_layer-[facet2(1,4),facet2(1,3)],[facet2(2,4),facet2(2,3)],[facet2(3,4),facet2(3,3)],'r','Linewidth',1);hold on;
   
   %% д��dxf�ļ�
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
%% ����λ��ÿ�����㴦��Բ��
if aux(1)~=0 || aux(2)~=0 || aux(4)~=0
    % ��������ж��������,������ƽ�Ƶ�x������
    for i=1:2:k
        facet=Rotate_Matrix(i,p)*basic_facet(i);
        for j=1:1:layer
            % ������ά����
            H_layer=(2*j-1)*h_layer;
            facet3(i,2*j-1,1:3)=[H_layer+facet(1,2),facet(2,2),facet(3,2)];
            facet3(i,2*j,1:3)=[H_layer+facet(1,1),facet(2,1),facet(3,1)];
            facet3(i+1,2*j-1,1:3)=[H_layer+facet(1,3),facet(2,3),facet(3,3)];
            facet3(i+1,2*j,1:3)=[H_layer+facet(1,4),facet(2,4),facet(3,4)];
        end
        facet3(i,2*j+1,1:3)=[(2*j+1)*h_layer+facet(1,2),facet(2,2),facet(3,2)];
        facet3(i+1,2*j+1,1:3)=[(2*j+1)*h_layer+facet(1,3),facet(2,3),facet(3,3)];
    end

    i=i+2; %iΪ������1����,��2��Ϊ���һ����
    facet=Rotate_Matrix(i-1,p)*basic_facet(i-1);
    for j=1:1:layer
        % ������ά����
        H_layer=(2*j-1)*h_layer;
        facet3(i,2*j-1,1:3)=[H_layer+facet(1,3),facet(2,3),facet(3,3)];
        facet3(i,2*j,1:3)=[H_layer+facet(1,4),facet(2,4),facet(3,4)];
    end
    facet3(i,2*j+1,1:3)=[(2*j+1)*h_layer+facet(1,3),facet(2,3),facet(3,3)];   
%     save facet3.mat facet3

    %ע��������ʱ����sita�����һ��ֵ��i��Ҫ��һ�ﵽ���һ����
    if n==3
        i=i-1;  
    end

    %������Χ���и���
    Cut_origin(1:3)=facet3(1,1,1:3);
    Cut_left(:,1)=facet3(1,:,1);Cut_left(:,2)=facet3(1,:,2);Cut_left(:,3)=facet3(1,:,3);
    Cut_right(:,1)=facet3(i,:,1);Cut_right(:,2)=facet3(i,:,2);Cut_right(:,3)=facet3(i,:,3);
    if aux(4)==0
        Cut_right_f=[flipud(Cut_right(:,1)),flipud(Cut_right(:,2)),flipud(Cut_right(:,3))]; %����˳��������浽������
        Cut_line=[Cut_left;Cut_right_f;Cut_origin];%�����ջ���Χ��
        plot3(Cut_line(:,1),Cut_line(:,2),Cut_line(:,3),'-k'); hold on;
        if dxf == 1
            dxf_polyline(FID,Cut_line(:,1),Cut_line(:,2),Cut_line(:,3));
        end
    end
end

%% ��������
if aux(4)>0
    % ���㿨�۵Ķ�������
    x0=facet3(1,1,1); y0=facet3(1,1,2); 
    x0_end=facet3(i,1,1); y0_end=facet3(i,1,2);

    D_1=b(1)/1.5; D_2=d(1)/4; %ȷ�����λ��
    D_L=d(1)/4; D_W=d(1)/10; %ȷ�������С
    D_slope=sita(1);

    % ������������µĿ�����״
    if n==4 || n==3
        D_1=b(1)/3;
    end
    if b(1)<D_W  %��n>4, L=2W
        D_1=a(1)/6; D_2=d(1)/6; %ȷ�����λ��
        D_L=d(1)/4; D_W=d(1)/10; %ȷ�������С
        D_slope=(sita(1));
    end

    %��������෽��
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

    %�������Ҳ�͹��
    
    if sita(i)>90 || n==3  %�����������
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
    Convex2=[2*h_layer-flipud(Convex0(1:9,1)),flipud(Convex0(1:9,2)),flipud(Convex0(1:9,3))]; % �Գƺ���Ҫ��ת˳����µ���
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
    % ������Χ��������
    Cut_right_f=[flipud(Cut_right(:,1)),flipud(Cut_right(:,2)),flipud(Cut_right(:,3))]; %����˳��������浽������
    Cut_line=[Cut_left;Cut_right_f;Cut_origin];%�����ջ���Χ��
    plot3(Cut_line(:,1),Cut_line(:,2),Cut_line(:,3),'-k'); hold on;
    if dxf == 1
        dxf_polyline(FID,Cut_line(:,1),Cut_line(:,2),Cut_line(:,3));
    end
end

%% ����Բ�ף��ų����ܶ���
if aux(1)>0
    %����ӿ���ʱ��ĩ��Ҳ��Ҫ���
    if aux(4)==0
        Max_i=i-1;
    else
        Max_i=i;
    end

    for index_i=2:1:Max_i %����֮ǰ��ѭ����i��jָʾĩ��λ��
        for index_j=2:1:2*layer
            %draw auxiliary circle
            Center(1)=facet3(index_i,index_j,1);
            Center(2)=facet3(index_i,index_j,2); % aux(1)��ֱ��
            rectangle('Position',[Center-aux(1)/2,aux(1),aux(1)],'Curvature',[1,1],'EdgeColor','k','linewidth',0.6);hold on;
        end
    end
    % �����dxf�ļ�
    if dxf == 1
        % ����Բ�ף��ų����ܶ���
        for index_i=2:1:Max_i %����֮ǰ��ѭ����i��jָʾĩ��λ��
            for index_j=2:1:2*layer
                dxf_circle(FID,facet3(index_i,index_j,:),0.5); %Բ�װ뾶0.5mm
            end
        end
    end

end
%% ����������
if aux(2)>0

    % ��ʾ���ĸ����Ե����x��y���꣬���ڴ˻���������10mm��������
    Min_y=min(facet3(1,:,2))-aux(2); Max_y=max(facet3(i,:,2))+aux(2);
    Min_x=min(facet3(:,1,1))-aux(2); Max_x=max(facet3(:,2*layer+1,1))+aux(2);
    if aux(4)>0
        Max_y=y5_end+aux(2);
    end
    %     Min_z=0; Max_z=0; %��ֽͼ��λ��x-yƽ�棬zʼ��Ϊ0
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

