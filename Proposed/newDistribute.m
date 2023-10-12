function mobileLoc = newDistribute( in, networkSize )

ma = in/2;
mi = in/4;


mobileLoc1  = (networkSize/2)*rand(ma,2);
mobileLoc2  = (networkSize/2)*rand(mi,2);
mobileLoc2(:,2) = mobileLoc2(:,2)+(networkSize/2);
mobileLoc3  = (networkSize/2)*rand(mi,2);
mobileLoc3(:,2) = mobileLoc3(:,1)+(networkSize/2);

mobileLoc = [mobileLoc1;mobileLoc2;mobileLoc3];
end

