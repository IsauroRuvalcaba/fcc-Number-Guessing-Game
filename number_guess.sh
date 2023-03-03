#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USER_NAME_INPUT

# random_num () {
#   r=$(( $RANDOM % 1001 ));
#   echo $r
# }

MY_NUM=$(( $RANDOM % 1001))
echo $MY_NUM

USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name='$USER_NAME_INPUT'")

if [[ -z $USER_ID ]]
then
  echo -e "\nWelcome, $USER_NAME_INPUT! It looks like this is your first time here."
  INSERT_USER_DATA=$($PSQL "INSERT INTO users(user_name) VALUES('$USER_NAME_INPUT')")
  
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT min(tries) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USER_NAME_INPUT! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

TRIES=0


echo -e "\nGuess the secret number between 1 and 1000:"
until [[ $GUESS -eq $MY_NUM ]]
do
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
  TRIES=$(( $TRIES+1 ))
    if [[ $GUESS -gt $MY_NUM ]]
    then
      echo "It's lower than that, guess again:"
    elif  [[ $GUESS -lt $MY_NUM ]]
    then
       echo "It's higher than that, guess again:"
    # else 
    #   break
    fi          
  fi
done

USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name='$USER_NAME_INPUT'")
INSERT_GAME_DATA=$($PSQL "INSERT INTO games(user_id, tries) VALUES($USER_ID, $TRIES)")


echo "You guessed it in $TRIES tries. The secret number was $MY_NUM. Nice job!"
