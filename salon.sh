#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ Relaxation Salon ~~~~~"

SERVICES(){
  #print first argument
  echo -e "\n$1"

  #get service list and format it
  SERVICE_LIST=$($PSQL "SELECT * FROM services;" | sed 's/|/) /') 
  echo -e "$SERVICE_LIST"

  read SERVICE_ID_SELECTED
  #check if it is a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^([0-9]+)$ ]]
  then
    #not a number
    SERVICES "Please input a number!"
  else
    #get the service name
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

    #check if service exists
    if [[ -z $SERVICE_NAME ]]
    then
      #it doesnt exist
      SERVICES "Service not found!"
    else
      #get customer phone
      echo -e "\nPlease enter your phone number:"
      read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
      
      #check if customer doesnt exists
      if [[ -z $CUSTOMER_NAME ]]
      then
        #get name
        echo -e "\nPlease enter your name:"
        read CUSTOMER_NAME

        #create customer
        CUSTOMER_CREATION_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
      fi

      #get customer id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

      #get service time
      echo -e "\nPlease enter the time you will come:"
      read SERVICE_TIME

      #create an appointment
      APPOINTMENT_CREATION_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi
}

SERVICES "What service do you want to get?"