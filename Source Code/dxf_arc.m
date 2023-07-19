function FID = dxf_arc(FID, center, radius, angle)
try
    if FID.dump
        fprintf(FID.fid,'0\n');
        fprintf(FID.fid,'ARC\n');
         
        dxf_print_layer(FID);
        fprintf(FID.fid,'66\n');  % entities follow (not necessary)
        fprintf(FID.fid,'1\n');
         
        fprintf(FID.fid,'10\n');
        fprintf(FID.fid,[num2str(center(1)),'\n']);
        fprintf(FID.fid,'20\n');
        fprintf(FID.fid,[num2str(center(2)),'\n']);
        fprintf(FID.fid,'30\n');
        fprintf(FID.fid,[num2str(center(3)),'\n']);
        fprintf(FID.fid,'40\n');
        fprintf(FID.fid,[num2str(radius),'\n']);
        fprintf(FID.fid,'50\n');
        fprintf(FID.fid,[num2str(angle(1)),'\n']);
        fprintf(FID.fid,'51\n');
        fprintf(FID.fid,[num2str(angle(2)),'\n']);
    end
 
catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end