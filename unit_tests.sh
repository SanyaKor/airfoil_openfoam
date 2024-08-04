#!/bin/bash

tests_amount=30
curr_tests_amount=1



if [ $# -eq 0 ]
then
    echo "(DEFAULT VALUE) TESTS: $tests_amount"
else
    if [ $1 -gt 0 ] && [ $1 -le $tests_amount ] 
    then 
        tests_amount=$1
        echo "(ASSIGNED VALUE)TESTS: $tests_amount"
    else
        echo "ERROR : TESTS AMOUNT SHOULD BE GT 0 AND LE $tests_amount"
        exit
    fi
fi

 

echo -n  $command 


if [[ ! -e "AIRFOIL_TESTS" ]]; 
then
    mkdir -p "AIRFOIL_TESTS"
    curr_tests_amount=1
else
    curr_tests_amount=$(cd AIRFOIL_TESTS && find . -name "TESTS*" -printf '.' | wc -m)
    curr_tests_amount=$((curr_tests_amount+1))
    current_date_time=$(date -d '+2 hour' '+%Y-%m-%d_%H-%M-%S' )
    command=$(cd AIRFOIL_TESTS && mkdir "TESTS${curr_tests_amount}_${current_date_time}" )
    echo -n $command
fi


readarray angles_array < angles.txt   

command=$(cp ./angles.txt ./AIRFOIL_TESTS/TESTS${curr_tests_amount}_${current_date_time}/)
echo $command

for (( test_case=0; test_case<tests_amount; test_case++ ))
do     
    
    current_angle=${angles_array[$test_case]}
    
    command=$(sed -i "/internalField   uniform/c \\${current_angle}"  ./0/U)
    echo -n $command

    echo "TEST_CASE $test_case"
    simpleFoam &> /dev/null   
    
    command=$(cp ./postProcessing/forcesCoeffs/0/coefficient.dat ./AIRFOIL_TESTS/TESTS${curr_tests_amount}_${current_date_time})
    echo -n $command

    
    command=$(mv ./AIRFOIL_TESTS/TESTS${curr_tests_amount}_${current_date_time}/coefficient.dat ./AIRFOIL_TESTS/TESTS${curr_tests_amount}_${current_date_time}/TEST_CASE${test_case}.dat )
    echo -n $command

    sh ./cleaner.sh
done


