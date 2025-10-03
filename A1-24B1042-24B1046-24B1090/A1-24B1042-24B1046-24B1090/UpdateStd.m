function newStd = UpdateStd ( OldMean , OldStd , NewMean ,NewDataValue , n )
    var =(( OldStd .^2) *( n -1) + ( OldMean .^2) *( n ) + NewDataValue .^2) /n - NewMean .^2*( n +1) / n ;
    newStd = sqrt ( var ) ;
end