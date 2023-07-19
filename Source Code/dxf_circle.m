function FID = dxf_circle(FID, center, radius)
try
    if FID.dump
        fprintf(FID.fid,'0\n');
        fprintf(FID.fid,'CIRCLE\n');
         
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
    end
 
catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end