import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late String equation = "";
  late String result = "";

  bool isDecimalAdded = false; // Track if a decimal point is added

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "";
        result = "";
        isDecimalAdded = false; // Reset the decimal point flag
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation.endsWith(".")) {
          isDecimalAdded = false; // Update the decimal point flag
        }
      } else if (buttonText == "×") {
        equation += "*"; // Use "*" for multiplication
        isDecimalAdded = false; // Reset the decimal point flag
      } else if (buttonText == "÷") {
        equation += "/"; // Use "/" for division
        isDecimalAdded = false; // Reset the decimal point flag
      } else if (buttonText == "%") {
        if (equation.isNotEmpty) {
          // Calculate the percentage and update the equation
          final num percentageValue = double.parse(equation) / 100;
          equation = percentageValue.toString();
          result = equation;
          isDecimalAdded = true; // Update the decimal point flag
        }
      } else if (buttonText == "=") {
        try {
          Parser parser = Parser();
          Expression exp = parser.parse(equation);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      }  else if (buttonText == "." && !isDecimalAdded && equation.isNotEmpty) {
        // Check if the last character in equation is not a dot
        if (!equation.endsWith(".")) {
          equation += buttonText; // Append "." only if not already present
          isDecimalAdded = true; // Update the decimal point flag
        }
      } else {
        equation += buttonText;
      }
    });
  }

  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor, {bool isCircular = false}) {
    // Define a variable to store the text color
    Color textColor = Colors.white;

    // Check the button text and set the text color accordingly
    if (["C", "⌫", "%", "÷", "×", "+", "-"].contains(buttonText)) {
      textColor = Colors.orange;
    }

    return Container(
      height: 50 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: isCircular ? 20.0 : 24.0, // Adjust font size for circular button
            fontWeight: FontWeight.normal,
            color: textColor, // Set the text color
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black, // Set the background color to black
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          EquationWidget(equation: equation),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
            child: Text(
              result,
              style: const TextStyle(fontSize: 48.0, color: Colors.white), // Set font color to white
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton("C", 1, Colors.black),
                        buildButton("⌫", 1, Colors.black),
                        buildButton("%", 1, Colors.black),
                        buildButton("÷", 1, Colors.black),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("7", 1, Colors.black),
                        buildButton("8", 1, Colors.black),
                        buildButton("9", 1, Colors.black),
                        buildButton("×", 1, Colors.black),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("4", 1, Colors.black),
                        buildButton("5", 1, Colors.black),
                        buildButton("6", 1, Colors.black),
                        buildButton("-", 1, Colors.black),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("1", 1, Colors.black),
                        buildButton("2", 1, Colors.black),
                        buildButton("3", 1, Colors.black),
                        buildButton("+", 1, Colors.black),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("00", 1, Colors.black),
                        buildButton("0", 1, Colors.black),
                        buildButton(".", 1, Colors.black),
                        buildButton("=", 1, Colors.deepOrange, isCircular: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EquationWidget extends StatelessWidget {
  const EquationWidget({
    Key? key,
    required this.equation,
  }) : super(key: key);

  final String equation;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
      child: Text(
        equation,
        style: const TextStyle(fontSize: 30.0, color: Colors.white), // Set font color to white
      ),
    );
  }
}
