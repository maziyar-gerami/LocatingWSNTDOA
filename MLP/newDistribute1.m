function mobileLoc = newDistribute1( in, networkSize )

ma = in/2;
mi = in/4;


mobileLoc1  = (networkSize/2)*rand(25,2);
mobileLoc2  = (networkSize/2)*rand(50,2);
mobileLoc2(:,1) = mobileLoc2(:,1)+(networkSize/2);
mobileLoc3  = (networkSize/2)*rand(25,2);
mobileLoc3(:,2) = mobileLoc3(:,2)+(networkSize/2);
mobileLoc4  = (networkSize/2)*rand(125,2);
mobileLoc4  = mobileLoc4 + (networkSize/2);
mobileLoc = [mobileLoc1;mobileLoc2;mobileLoc3;mobileLoc4];
end


