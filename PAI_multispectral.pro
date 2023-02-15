
; Calculation of polygon area index (PAI) for WorldView-2 and WorldView-3.
; If you want to use this code for some analysis, 
; please cite the paper "Effect of the spectral area index created by three algorithms for tree specifications recognition".

pro PAI_multispectral
  
  envi, /restore_base_save_files
  envi_batch_init, log_file='batch.txt'
  
  files = 'C:\Users\X1\Desktop\WorldView-2'  ; You can replace it with your data storage address
  envi_open_file, files, r_fid=fid
  envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims, $
    data_type=data_type, interleave=interleave, offset=offset
  map_info=envi_get_map_info(fid=fid)
  pos=indgen(nb)
  data=make_array(ns, nl, nb, type=data_type)
  
  
  for k=0, nb-1 do begin
    data[*, *, k]=envi_get_data(fid=fid, dims=dims, pos=k)
  endfor
    
    PAI=fltarr(ns, nl, 1,/no)
     
   for w=0, nb-2 do begin
    PAI2=0 ; When algorithms 1 and 3 are used, "PAI2" should be replaced by "PAI1" and "PAI3" respectively.
    for m=w, nb-2 do begin ; nb represents the number of bands of remote sensing data
        n=m+1
    data1=data[*, *, m] 
    data2=data[*, *, n]
    o=1 ; When algorithm 3 is used, O is the value of band sequence number - 1, and O is assigned according to the specific band involved.
    data3=data[*, *, o]  ; The value of o is an integer from 1 to nb+1, When the value is 1, it means that the first band participates in the operation, 
                         ; 2 means that the second band participates in the operation, and so on
  
    arr=[0.425, 0.480, 0.545, 0.605, 0.660, 0.725, 0.8325, 0.950] ;You can manually enter the wavelength of each wave band, or use [Start: End: Step] to set it
       
          z=arr[n]-arr[m]
      
             c=0.06 ;c is a constant, change the value of c according to specific calculation   
             
         PAI2= PAI2+0.5*(data1+data2-2*c)*z  ;This formula is the algorithm 2 in my paper
         
         ; When using algorithm 1 to extract polygon area index, you can use this formula: PAI1=PAI1+0.5*(data1+data2)*z
         ; When using algorithm 3 to extract polygon area index, you can use this formula: PAI3=PAI3+ 0.5*(data1+data2-2*data3)*z
    
            
   fname='PAI2'+string(w+1, format='(i2)')+' to'+string(m+2, format='(i2)')+'.dat'
  envi_write_envi_file, PAI2, out_name=fname, ns=ns, nl=nl, nb=1, data_type=4, $
    interleave=interleave, offset=offset, map_info=map_info
              
    endfor
         
   endfor
   
end


