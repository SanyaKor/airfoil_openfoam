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


declare -a drag_array
declare -a lift_array

# Чтение файла и заполнение массивов
while IFS=$'\t' read -r col1 col2; do
    # Добавляем строки в массивы
    drag_array+=("$col1")
    lift_array+=("$col2")
done < "./angles.txt"      

command=$(cp ./angles.txt ./AIRFOIL_TESTS/TESTS${curr_tests_amount}_${current_date_time}/)
echo $command

for (( test_case=0; test_case<tests_amount; test_case++ ))
do     
    
    current_angle=${drag_array[$test_case]}
    current_lift=${lift_array[$test_case]}
    
    #command=$(sed -i "/internalField   uniform/c $current_angle"  ./0/U)
    command=$(sed -i "s/\(internalField   uniform \).*/\1 $current_angle/" ./0/U)
    echo -n $command

    command=$(sed -i "s/\(liftDir     \).*/\1 $current_lift/" ./system/controlDict)
    echo -n $command

    command=$(sed -i "s/\(dragDir     \).*/\1 $current_angle/" ./system/controlDict)
    echo -n $command


    echo "TEST_CASE $test_case"
    simpleFoam &> /dev/null   
    
    command=$(cp ./postProcessing/forcesCoeffs/0/coefficient.dat ./AIRFOIL_TESTS/TESTS${curr_tests_amount}_${current_date_time})
    echo -n $command

    
    command=$(mv ./AIRFOIL_TESTS/TESTS${curr_tests_amount}_${current_date_time}/coefficient.dat ./AIRFOIL_TESTS/TESTS${curr_tests_amount}_${current_date_time}/TEST_CASE${test_case}.dat )
    echo -n $command

    sh ./cleaner.sh
done


