function seam = mySeamCarving(s) %s represents STFT time-frequency matrix
    E=log(abs(s).^2);
    
    [ freq , time ] = size(E); % y : freq. , x: time
    C = zeros(freq,time); %cumulative energy
    P = zeros(freq,time); % paths for seams
    for j=1:time %time
        for  i=2 : freq-1 %frequency range from 2 ~ freq-1 (exclude the first/last freq.)
            if j==1
                C(i,j)=E(i,j);
            else
                h=i-1:i+1;
                [ tem , p ] = max( C(h,j-1) );
                C( i , j ) = tem + E( i , j );
                P( i , j ) = h( p );
            end
        end
    end
    
    [ ~ , p ] = max( C ( : , end ) );
    seam=zeros(1,time);
    seam(1,end) = p;
    backTracking = P( p , end ) ;
    for i = time:-1:2
        seam(1,i-1)= backTracking;
        backTracking = P( backTracking , i-1 ) ;
    end
    seam = smooth(seam,'rlowess');
end