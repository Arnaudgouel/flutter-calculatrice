import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ma Calculatrice',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CalculatorScreen(),
    );
  }
}

/*
* Chaque bouton appelle _onButtonPressed(value), qui met à jour l’état de l’application via setState().
* Une variable _firstOperand stocke le premier nombre entré.
* Une variable _operator stocke l’opérateur sélectionné.
* Lorsqu’un utilisateur appuie sur "=", le deuxième nombre est récupéré et le calcul est effectué.
*
* Mes difficultés que j'ai rencontrées
*
* Gestion des entrées utilisateur. Problème : L’utilisateur pouvait entrer plusieurs zéros en début de saisie, ou concaténer les opérations sans validation.
* Solution : Ajout d’une variable _isNewInput pour effacer l’affichage lors d’une nouvelle entrée.
*
* Gestion des erreurs mathématiques. Problème : Division par zéro entraînait un plantage de l’application.
* Solution : Ajout d’un test if (secondOperand != 0) pour afficher "Erreur" en cas de division par zéro.
*
* Affichage de nombres à virgule flottante. Problème : Le résultat affichait des nombres avec trop de décimales (ex: 2.0000000001).
* Solution : Arrondi automatique via .toStringAsFixed(2) (option que l'on pourrait ajouter pour améliorer la lisibilité).
*
* J'ai encore le problème d'affichage du resultat avec une virgule puis un zero même si le nombre est un entier.
* Je m'arrête sur ça pour ne pas passer encore trop de temps sur l'application
*/

class CalculatorScreen extends StatefulWidget {

  const CalculatorScreen({super.key});
  //@override
  //_CalculatorScreenState createState() => _CalculatorScreenState();
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = "0";
  String _operator = "";
  double? _firstOperand;
  bool _isNewInput = true;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = "0";
        _operator = "";
        _firstOperand = null;
        _isNewInput = true;
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _operator = value;
        _firstOperand = double.tryParse(_display);
        _isNewInput = true;
      } else if (value == '=') {
        if (_firstOperand != null && _operator.isNotEmpty) {
          double secondOperand = double.tryParse(_display) ?? 0;
          switch (_operator) {
            case '+':
              _display = (_firstOperand! + secondOperand).toString();
              break;
            case '-':
              _display = (_firstOperand! - secondOperand).toString();
              break;
            case '×':
              _display = (_firstOperand! * secondOperand).toString();
              break;
            case '÷':
              _display = secondOperand != 0 ? (_firstOperand! / secondOperand).toString() : "Erreur";
              break;
          }
          _operator = "";
          _firstOperand = null;
        }
      } else {
        if (_isNewInput || _display == "0") {
          _display = value;
        } else {
          _display += value;
        }
        _isNewInput = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculatrice Flutter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(20),
              child: Text(
                _display,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              padding: EdgeInsets.all(10),
              itemCount: _buttons.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () => _onButtonPressed(_buttons[index]),
                  child: Text(
                    _buttons[index],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  final List<String> _buttons = [
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    'C', '0', '=', '+'
  ];
}

