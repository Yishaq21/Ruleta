#!/bin/bash

#Colours   
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m" 


function ctrl_c(){
  echo -e "\n\n[!] Saliendo..\n"
  exit 1
}

#CTRL+C 
trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}-m${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}-t${endColour} Tecnica a utilizar${endColour}${purpleColour}(${endColour}${endColour}${yellowColour}Martingala${endColour}${blueColour}/${endColour}${yellowColour}InverseLabrouchere${endColour}${purpleColour})${endColour}\n"
  exit 1
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}$money₡${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ¿Cuanto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet
  echo -ne "${yellowColour}[+]${endColour} ¿ A que deseas apostar continuamente (par/impar)? ->${endColour} " && read par_impar

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de ${endColour}${yellowColour}$initial_bet₡${endColour}${grayColour} a${endColour}${yellowColour} $par_impar${endColour}"

  back_bet=$initial_bet
  play_counter=1
  jugadas_malas=""

  tput civis #ocultar el cursor
  while true; do 
    money=$(($money-$initial_bet))
#    echo -e "\n${yellowColour}[+]${endColour} Acabas de apostar${endColour}${yellowColour} $initial_bet₡${endColour}${grayColour} y tienes${endColour}${yellowColour} $money₡${endColour}"
    random_number="$(($RANDOM % 37))"
#     echo -e "${yellowColour}[+]${endColour} Ha salido el numero ${endColour}${blueColour}$random_number${endColour}"
    

    if [ ! "$money" -le 0 ]; then
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
#            echo -e "${redColour}[+] Ha salido el 0, por lo tanto perdemos${endColour}"
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en ${endColour}${yellowColour}$money₡${endColour}"
          else 
#            echo -e "${yellowColour}[+]${endColour}${greenColour} El numero que ha salido es par, ¡Ganas!${endColour}"
            reward=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de ${endColour}${yellowColour}$reward₡${endColour}"
            money=$(($money+$reward))
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes ${endColour}${yellowColour}$money₡${endColour}"
            initial_bet=$back_bet
            jugadas_malas=""
          fi 
        else 
#          echo -e "${yellowColour}[+]${endColour}${redColour} El numero que ha salido es impar ¡Pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en ${endColour}${yellowColour}$money₡${endColour}"
        fi
      else
        #Todo esto es para cuando apostamos por numeros impares
        if [ "$(($random_number % 2))" -eq 1 ]; then
#         echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es impar, ¡ganas!${endColour}"
          reward=$(($initial_bet*2))
#        echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de ${endColour}${yellowColour}$reward₡${endColour}"
          money=$(($money+$reward))
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes ${endColour}${yellowColour}$money₡${endColour}"
          initial_bet=$back_bet
          jugadas_malas=""
        else
      #     echo -e "${yellowColour}[+]${endColour}${redColour} El numero que ha salido es par, ¡Pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
 #        echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en ${endColour}${yellowColour}$money₡${endColour}"
        fi
      fi
    else 
      # Nos quedamos sin dinero
      echo -e "\n${redColour} [!] Te quedaste sin plata${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de ${endColour}${yellowColour}$play_counter${endColour}${grayColour} jugadas${endColour}"
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuacion se van a representar las malas jugadas consecutivas que han salido:${endColour}\n"
      echo -e "${blueColour}[$jugadas_malas]${endColour}"
      tput cnorm; exit 0
    fi

    let play_counter+=1
  done

  tput cnorm # Recuperar el cursor
}

function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}$money₡${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ¿ A que deseas apostar continuamente (par/impar)? ->${endColour} " && read par_impar
  
  declare -a my_sequence=(1 2 3 4)

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
  
  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

  jugadas_totales=0 
  bet_to_renew=$(($money+50))

  echo -e "${yellowColour}[+]${endColour}${grayColour} El tope a renovar la secuencia esta establecido por encima de los ${endColour}${yellowColour}$bet_to_renew${endColour}"
  
   
  tput civis 

  while true; do
      let jugadas_totales+=1
      random_number=$(( $RANDOM % 37))
      money=$(($money - $bet))
      if [ ! "$money" -lt 0 ]; then 
        echo -e "${yellowColour}[+]${endColour}${grayColour} Invertimos ${endColour}${yellowColour}$bet₡${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos ${endColour}${yellowColour} $money₡${endColour}"
       
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha saliedo el numero ${endColour}${blueColour}$random_number${endColour}"

        if [ "$par_impar" == "par" ]; then
          if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero es par ¡Ganas!${endColour}"
            reward=$(($bet*2))
            let money+=$reward
            echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes ${endColour}${yellowColour}$money₡${endColour}"

            if [ $money -gt $bet_to_renew ]; then
              echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de ${endColour}${yellowColour}$bet_to_renew${endColour}${grayColour} Establecidos prar renovar nuestra secuencia${endColour}"
              bet_to_renew=$(($bet_to_renew + 50))
              echo -e "${yellowColour}[+]${endColour}${grayColour} El tope se ha establecido en${endColour}${yellowColour} $bet_to_renew${endColour}"
              my_sequence=(1 2 3 4)
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a :${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
            else  
              my_sequence+=($bet)
              my_sequence=(${my_sequence[@]})

              echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra secuencia nueva es ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
            if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" ]; then
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]; then
                bet=${my_sequence[0]}
            else 
              
              echo -e "${redColour}[¡] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi
        fi
        elif [ "$((random_number % 2))" -eq 1 ] || [ "$random_number" -eq 0 ]; then
          if [ "$((random_number % 2))" -eq 1 ]; then
            echo -e "${redColour}[!] El numero es impar, ¡Pierdes!${endColour}"
          else 
            echo -e "${redColour}[!] El numero es 0 ,¡Pierdes!${endColour}"
          fi
          if [ $money -lt $(($bet_to_renew-100)) ]; then
            echo -e "${yellowColour}[+]${endColour}${grayColour} Hemos llegado a un minimo critico, se procede a reajustar el tope${endColour}"
            bet_to_renew=$(($bet_to_renew - 100))
            echo -e "${yellowColour}[+]${endColour} El tope ha sido renovado a${endColour}${yellowColour}$bet_to_renew"
          
            unset my_sequence[0]
            unset my_sequence[-1] 2 >/dev/null

            my_sequence=(${my_sequence[@]})

            echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra secuencia nueva es ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
          if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" ]; then
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else 
              
            echo -e "${redColour}[¡] Hemos perdido nuestra secuencia${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi 
          else 
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            
            my_sequence=(${my_sequence[@]})

            echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se nos queda de la siguiente forma:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
            if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else 
              echo -e "${redColour}[¡] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi 
          fi
        fi
      fi
    else 
      echo -e "\n${redColour}[!] Se quedo sin plata pobre${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} En toral han habido ${endColour}${yellowColour}$jugadas_totales${endColour}${grayColour} Jugadas torales${endColour}\n"
      tput cnorm; exit 1
    fi
    
  done
  tput cnorm

}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else 
    echo -e "\n${redColour}[!] La tecnica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
