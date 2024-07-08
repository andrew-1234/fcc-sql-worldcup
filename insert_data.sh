#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams")
tail -n +2 games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals; do
  echo $($PSQL "insert into teams (name) values ('$winner') on conflict do nothing")
  echo $($PSQL "insert into teams (name) values ('$opponent') on conflict do nothing")
done

tail -n +2 games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals; do
  echo $($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ('$year', '$round', (select team_id from teams where name = '$winner'), (select team_id from teams where name = '$opponent'), '$winner_goals', '$opponent_goals')")
done

