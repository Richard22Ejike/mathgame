import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathgame/Util/button.dart';
import 'package:mathgame/Util/result.dart';
import 'package:mathgame/const.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // number pad list
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
    '-',
  ];

  int timeleft = 100;

 void _startcountdown(){
  Timer.periodic(Duration(seconds: 1 ), (timer) {
    if((timeleft > 0)){
      setState(() {
      timeleft--;
    });
    
    }
    else{
      timer.cancel();
    }
  });
  
 }


  // number A, number B
  int numberA = 1;
  int numberB = 1;

  String operationSign = '+';

   int   correctAnswer = 2;
   int operation = 0; 

  // user answer
  String userAnswer = '';

  int questionsAttempted = 0, numCorrect = 0; 

  // user tapped a button
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        // calculate if user is correct or incorrect
        checkResult();
      } else if (button == 'C') {
        // clear the input
        userAnswer = '';
      } else if (button == 'DEL') {
        // delete the last number
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        // maximum of 3 numbers can be inputted
        userAnswer += button;
      }
    });
  }
  //check if user is correct 5 in a role
  void showdialog() {
  
          showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
              message: '  Good Job!\nCorrect = $numCorrect \nattempts = $questionsAttempted',
              onTap: goToNextQuestion,
              icon: Icons.arrow_forward,
            );
          });
    
  }

  void nextoperation() {
     // reset values
    setState(() {
      userAnswer = '';
    });
   // create a new question
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);
    operation = randomNumber.nextInt(3);
    switch (operation) {
 case 0: //addition question
 correctAnswer = (numberA + numberB) ;
 operationSign= '+' ;
 break;
 case 1: //subtraction question
 correctAnswer = (numberA - numberB) ;
 operationSign= '-' ;
 break;
 case 2: //multiplication question
 correctAnswer = (numberA * numberB) ;
 operationSign= '*' ;
 break;
 default:
 break;
 }
  }
  

  // check if user is correct or not
  void checkResult() {
     

     if(timeleft == 100){
    _startcountdown();;
  }
     
 
    if (correctAnswer  == int.parse(userAnswer)) {
      numCorrect++;
      questionsAttempted++;
      nextoperation();
      
    } else {
      questionsAttempted++;
      nextoperation();
    }
    if(timeleft == 0){
    showdialog();
  }
     
  }

  // create random numbers
  var randomNumber = Random();

  // GO TO NEXT QUESTION
  void goToNextQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();

    timeleft = 100;
    numCorrect = 0;
    questionsAttempted = 0;

    // reset values
    setState(() {
      userAnswer = '';
    });

    // create a new question
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);
    operation = randomNumber.nextInt(3);
    switch (operation) {
 case 0: //addition question
 correctAnswer = (numberA + numberB) ;
 operationSign= '+' ;
 break;
 case 1: //subtraction question
 correctAnswer = (numberA - numberB) ;
 operationSign= '-' ;
 break;
 case 2: //multiplication question
 correctAnswer = (numberA * numberB) ;
 operationSign= '*' ;
 break;
 default:
 break;
 }
  }

  // GO BACK TO QUESTION
  void goBackToQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Column(
        children: [
          // level progress, player needs 5 correct answers in a row to proceed to next level
          Container(
            height: 160,
            color: Colors.deepPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Text(timeleft == 0 ? 'Times up ':timeleft.toString(),
               style: whiteTextStyle,),
               
              ],
            ),
          ),

          // question
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // question
                    Text(
                      numberA.toString() + ' $operationSign ' + numberB.toString() + ' = ',
                      style: whiteTextStyle,
                    ),

                    // answer box
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          userAnswer,
                          style: whiteTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // number pad
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                itemCount: numberPad.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: numberPad[index],
                    onTap: () => buttonTapped(numberPad[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}