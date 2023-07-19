function [] = Lineframe_odd(facet,hs,s,dxf)
%UNTITLED2 此处显示有关此函数的摘要
global FID FID_M FID_V
%   此处显示详细说明
    facet1_x=facet(1,1:4)';
    facet1_y=facet(2,1:4)';facet1_z=facet(3,1:4)';
    plot3([facet1_x(1),facet1_x(4)],[facet1_y(1),facet1_y(4)],[facet1_z(1),facet1_z(4)],'r','Linewidth',1);hold on;
    plot3([facet1_x(3),facet1_x(2)],[facet1_y(3),facet1_y(2)],[facet1_z(3),facet1_z(2)],'b-.','Linewidth',1);hold on;

%     plot3(2*hs-[facet1_x(1),facet1_x(4)],[facet1_y(1),facet1_y(4)],[facet1_z(1),facet1_z(4)],'r','Linewidth',1);hold on;
%     plot3(2*hs-[facet1_x(3),facet1_x(2)],[facet1_y(3),facet1_y(2)],[facet1_z(3),facet1_z(2)],'b-.','Linewidth',1);hold on;
    
    if s == 0
        plot3(2*hs-[facet1_x(3),facet1_x(2)],[facet1_y(3),facet1_y(2)],[facet1_z(3),facet1_z(2)],'b-.','Linewidth',1);hold on;
    end

    %% 绘制dxf文件
    if dxf == 1
    
        dxf_polyline(FID_M,[facet1_x(1),facet1_x(4)]',[facet1_y(1),facet1_y(4)]',[facet1_z(1),facet1_z(4)]');
        dxf_polyline(FID_V,[facet1_x(3),facet1_x(2)]',[facet1_y(3),facet1_y(2)]',[facet1_z(3),facet1_z(2)]');

%         dxf_polyline(FID_M,2*hs-[facet1_x(1),facet1_x(4)]',[facet1_y(1),facet1_y(4)]',[facet1_z(1),facet1_z(4)]');
%         dxf_polyline(FID_V,2*hs-[facet1_x(3),facet1_x(2)]',[facet1_y(3),facet1_y(2)]',[facet1_z(3),facet1_z(2)]');
        if s == 0
            dxf_polyline(FID_V,2*hs-[facet1_x(3),facet1_x(2)]',[facet1_y(3),facet1_y(2)]',[facet1_z(3),facet1_z(2)]');
        end        
    end

end

