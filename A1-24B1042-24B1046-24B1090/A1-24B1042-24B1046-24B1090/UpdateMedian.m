function newMedian = UpdateMedian(oldMedian, NewDataValue, A, n)
    if mod(n,2) == 0
        if  NewDataValue < A(n/2)
            newMedian = A(n/2);
        elseif NewDataValue > A(n/2 + 1)
            newMedian = A(n/2 + 1);
        else
            newMedian = NewDataValue;
        end
    else
        if NewDataValue >= A((n+1)/2 - 1) && NewDataValue <= A((n+1)/2 + 1)
            newMedian = (A((n+1)/2) + NewDataValue) / 2;
        elseif N < A((n+1)/2 - 1)
            newMedian = (A((n+1)/2 -1 ) + oldMedian)/2;
        else
            newMedian = (oldMedian + A((n+1)/2 + 1)) / 2;
        end
    end
end