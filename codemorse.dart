import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

//final Uri _url = Uri.parse('https://sites.google.com/view/stefanocavalli/home');
final Uri _url1 = Uri.parse('https://policies.google.com');
final Uri _url2 = Uri.parse('https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504');
/*
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
*/
Future<void> _launchUrl1() async {
  if (!await launchUrl(_url1)) {
    throw Exception('Could not launch $_url1');
  }
}
Future<void> _launchUrl2() async {
  if (!await launchUrl(_url2)) {
    throw Exception('Could not launch $_url2');
  }
}

class CodeMorsePage extends StatefulWidget {
  const CodeMorsePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CodeMorsePageState createState() => _CodeMorsePageState();
}

class _CodeMorsePageState extends State<CodeMorsePage> {
  String inputText = '';
  String morseCode = '';
  String decodedText = '';

  void convertToMorse() {
    setState(() {
      morseCode = textToMorse(inputText);
    });
  }

  void convertToText() {
    setState(() {
      decodedText = morseToText(inputText);
    });
  }

  String textToMorse(String text) {
    final morseCodeMap = {
      'A': '.-',
      'B': '-...',
      'C': '-.-.',
      'D': '-..',
      'E': '.',
      'F': '..-.',
      'G': '--.',
      'H': '....',
      'I': '..',
      'J': '.---',
      'K': '-.-',
      'L': '.-..',
      'M': '--',
      'N': '-.',
      'O': '---',
      'P': '.--.',
      'Q': '--.-',
      'R': '.-.',
      'S': '...',
      'T': '-',
      'U': '..-',
      'V': '...-',
      'W': '.--',
      'X': '-..-',
      'Y': '-.--',
      'Z': '--..',
      '0': '-----',
      '1': '.----',
      '2': '..---',
      '3': '...--',
      '4': '....-',
      '5': '.....',
      '6': '-....',
      '7': '--...',
      '8': '---..',
      '9': '----.',
      '!': '-.-.--',
      '-': '-....-',
      '+': '.-.-.',
      ':': '---...',
      '=': '-...-',
      "'": '.----.',
      ';': '-.-.-.',
      '@': '.--.-.',
      '\$': '...-..-',
      '?': '..--..',
      '"': '.-..-.',
      '(': '-.--.',
      ')': '-.--.-',
      ',': '--..--',
      ' ': '  /',
    };

    text = text.toUpperCase();
    String result = '';

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (morseCodeMap.containsKey(char)) {
        result += '${morseCodeMap[char]} ';
      }
    }

    return result.trim();
  }

  String morseToText(String morse) {
    final morseCodeMap = {
      '.-': 'A',
      '-...': 'B',
      '-.-.': 'C',
      '-..': 'D',
      '.': 'E',
      '..-.': 'F',
      '--.': 'G',
      '....': 'H',
      '..': 'I',
      '.---': 'J',
      '-.-': 'K',
      '.-..': 'L',
      '--': 'M',
      '-.': 'N',
      '---': 'O',
      '.--.': 'P',
      '--.-': 'Q',
      '.-.': 'R',
      '...': 'S',
      '-': 'T',
      '..-': 'U',
      '...-': 'V',
      '.--': 'W',
      '-..-': 'X',
      '-.--': 'Y',
      '--..': 'Z',
      '-----': '0',
      '.----': '1',
      '..---': '2',
      '...--': '3',
      '....-': '4',
      '.....': '5',
      '-....': '6',
      '--...': '7',
      '---..': '8',
      '----.': '9',
      '-.-.--': '!',
      '-....-' : '-',
      '.-.-.' : '+',
      '---...' : ':',
      '-...-' : '=',
      '.----.' : "'",
      '-.-.-.' : ';',
      '.--.-.' : '@',
      '...-..-' : '\$',
      '..--..' :'?',
      '.-..-.' :'"',
      '-.--.' :'(',
      '-.--.-' :')',
      '--..--' : ',',
      '-.-.-' :'starting signal to precede every transmission',
      '...-.-' :'end of work',
      '...-.' :'understood',
      '.-.-.-' :'stop (period)',
      '.-...' :'wait',
      '........' :'error',
      '/': ' ',
    };

    final List<String> codes = morse.split(' ');
    String result = '';

    for (int i = 0; i < codes.length; i++) {
      final code = codes[i];
      if (morseCodeMap.containsKey(code)) {
        result += morseCodeMap[code]!;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('Morse Code converter'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined), // Icona per tornare indietro
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer( // Definizione del menu laterale
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox( // Riduzione dell'altezza del DrawerHeader
              height: 100, // Imposta l'altezza desiderata
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('     Web sites'),
              onTap: () {
                _launchUrl();
              },
            ),
            ListTile(
              title: const Text('     Privacy Policy'),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (context) => const TextPagePrivacy(text: ' ', pageTitle: 'Privacy Policy',),
                );
                Navigator.push(context, route);
              },
            ),

            ListTile(
              title: const Text('     Rate the app'),
              onTap: () {
                // Action to perform when "Mail address" is selected
              },
            ),

          ],
        ),
      ),*/
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter words or morse characters separated by spaces.',
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Input Text / Morse Code (50 characters)',
              ),
              maxLength: 50,
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text('Convert to Morse'),
                  onPressed: () {
                    convertToMorse();
                  },
                ),
                ElevatedButton(
                  child: const Text('Convert to Text'),
                  onPressed: () {
                    convertToText();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Result after conversion:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              morseCode.isNotEmpty ? 'Morse Code: ' : '',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              morseCode.isNotEmpty ? ' $morseCode ' : '',
              style:
              const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              decodedText.isNotEmpty ? 'Decoded Text: ' : '',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              decodedText.isNotEmpty ? ' $decodedText' : '',
              style:
              const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Morse code conversion: Use / to add a space to separate words in morse code.",
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16.0),
            LayoutGrid(
              // ASCII-art named areas 🔥
              areas: '''
              A A1 B B1
              C C1 D D1
              E E1 F F1
              G G1 H H1
              I I1 J J1
              K K1 L L1
              M M1 N N1
              O O1 P P1
              Q Q1 R R1
              S S1 T T1
              U U1 V V1
              W W1 X X1
              Y Y1 Z Z1
              Z2 Z3 Z4 Z5
              W2 W3 W4 W5
              X2 X3 X4 X5
              X6 X7 X8 X9
              W6 W7 W8 W9
              0 00 1 11
              2 22 3 33
              4 44 5 55
              6 66 7 77
              8 88 9 99
              Y2 Y3 Y4 Y5
              ''',
              // Concise track sizing extension methods 🔥
              columnSizes: [100.px, 50.px, 100.px, 50.px],
              rowSizes: [
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                20.px,
                22.px,
                22.px,
                22.px,
                20.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                20.px
              ],
              // Column and row gaps! 🔥
              columnGap: 5,
              rowGap: 5,
              // Handy grid placement extension methods on Widget 🔥
              children: [
                gridArea('A').containing(
                  const Text(
                    "A alfa",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('A1').containing(
                  const Text(
                    ".-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('B').containing(
                  const Text(
                    "B bravo",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('B1').containing(
                  const Text(
                    "-...",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('C').containing(
                  const Text(
                    "C charlie",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('C1').containing(
                  const Text(
                    "-.-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('D').containing(
                  const Text(
                    "D delta",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('D1').containing(
                  const Text(
                    "-..",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('E').containing(
                  const Text(
                    "E echo",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('E1').containing(
                  const Text(
                    ".",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('F').containing(
                  const Text(
                    "F foxtrot",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('F1').containing(
                  const Text(
                    "..-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('G').containing(
                  const Text(
                    "G golf",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('G1').containing(
                  const Text(
                    "--.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('H').containing(
                  const Text(
                    "H hotel",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('H1').containing(
                  const Text(
                    "....",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('I').containing(
                  const Text(
                    "I india",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('I1').containing(
                  const Text(
                    "..",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('J').containing(
                  const Text(
                    "J juliett",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('J1').containing(
                  const Text(
                    ".---",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('K').containing(
                  const Text(
                    "K kilo",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('K1').containing(
                  const Text(
                    "-.-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('L').containing(
                  const Text(
                    "L lima",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('L1').containing(
                  const Text(
                    ".-..",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('M').containing(
                  const Text(
                    "M mike",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('M1').containing(
                  const Text(
                    "--",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('N').containing(
                  const Text(
                    "N november",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('N1').containing(
                  const Text(
                    "-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('O').containing(
                  const Text(
                    "O oscar",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('O1').containing(
                  const Text(
                    "---",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('P').containing(
                  const Text(
                    "P papa",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('P1').containing(
                  const Text(
                    ".--.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('Q').containing(
                  const Text(
                    "Q quebec",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('Q1').containing(
                  const Text(
                    "--.-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('R').containing(
                  const Text(
                    "R romeo",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('R1').containing(
                  const Text(
                    ".-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('S').containing(
                  const Text(
                    "S sierra",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('S1').containing(
                  const Text(
                    "...",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('T').containing(
                  const Text(
                    "T tango",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('T1').containing(
                  const Text(
                    "-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('U').containing(
                  const Text(
                    "U uniform",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('U1').containing(
                  const Text(
                    "..-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('V').containing(
                  const Text(
                    "V victor",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('V1').containing(
                  const Text(
                    "...-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('W').containing(
                  const Text(
                    "W whiskey",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('W1').containing(
                  const Text(
                    ".--",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X').containing(
                  const Text(
                    "X x-ray",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X1').containing(
                  const Text(
                    "-..-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('Y').containing(
                  const Text(
                    "Y yankee",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('Y1').containing(
                  const Text(
                    "-.--",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('Z').containing(
                  const Text(
                    "Z zulu",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('Z1').containing(
                  const Text(
                    "--..",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('W2').containing(
                  const Text(
                    "start",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('W3').containing(
                  const Text(
                    "-.-.-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('W4').containing(
                  const Text(
                    "stop (period)",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('W5').containing(
                  const Text(
                    ".-.-.-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X2').containing(
                  const Text(
                    "wait",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X3').containing(
                  const Text(
                    ".-...",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X4').containing(
                  const Text(
                    "error (8 dots)",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X5').containing(
                  const Text(
                    "........",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X6').containing(
                  const Text(
                    "understood",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X7').containing(
                  const Text(
                    "...-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X8').containing(
                  const Text(
                    "end of work",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('X9').containing(
                  const Text(
                    "...-.-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('0').containing(
                  const Text(
                    "0 nadazero",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('00').containing(
                  const Text(
                    "-----",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('1').containing(
                  const Text(
                    "1 unaone",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('11').containing(
                  const Text(
                    ".----",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('2').containing(
                  const Text(
                    "2 bissotwo",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('22').containing(
                  const Text(
                    "..---",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('3').containing(
                  const Text(
                    "3 terrathree",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('33').containing(
                  const Text(
                    "...--",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('4').containing(
                  const Text(
                    "4 kartefour",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('44').containing(
                  const Text(
                    "....-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('5').containing(
                  const Text(
                    "5 pantafive",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('55').containing(
                  const Text(
                    ".....",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('6').containing(
                  const Text(
                    "6 soxisix",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('66').containing(
                  const Text(
                    "-....",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('7').containing(
                  const Text(
                    "7 setteseven",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('77').containing(
                  const Text(
                    "--...",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('8').containing(
                  const Text(
                    "8 oktoeight",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('88').containing(
                  const Text(
                    "---..",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('9').containing(
                  const Text(
                    "9 novenine",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('99').containing(
                  const Text(
                    "----.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            LayoutGrid(
              // ASCII-art named areas 🔥
              areas: '''
              OO PP QQ RR SS TT
              UU VV ZZ K2 K3 K4
              DD EE FF AA BB CC
              GG HH II LL MM NN
              AA1 BB1 CC1 AA2 BB2 CC2
              GG1 HH1 II1 DD1 EE1 FF1
              UU1 VV1 ZZ1 LL1 MM1 NN1
              OO1 PP1 QQ1 RR1 SS1 TT1
              A21 B21 C21 D21 E21 F21
              ''',
              // Concise track sizing extension methods 🔥
              columnSizes: [10.px, 50.px, 88.px, 10.px, 50.px,10.px],
              rowSizes: [
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px,
                22.px
              ],
              // Column and row gaps! 🔥
              columnGap: 5,
              rowGap: 5,
              // Handy grid placement extension methods on Widget 🔥
              children: [
                gridArea('OO').containing(
                  const Text(
                    "?",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('PP').containing(
                  const Text(
                    '  ..--..',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('QQ').containing(
                  const Text(
                    '',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('RR').containing(
                  const Text(
                    '!',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('SS').containing(
                  const Text(
                    "  -.-.--",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('TT').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('UU').containing(
                  const Text(
                    "(",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('VV').containing(
                  const Text(
                    "  -.--.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('ZZ').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('K2').containing(
                  const Text(
                    ")",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('K3').containing(
                  const Text(
                    "  -.--.-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('K4').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('AA').containing(
                  const Text(
                    "-",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('BB').containing(
                  const Text(
                    '  -....-',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('CC').containing(
                  const Text(
                    '',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('DD').containing(
                  const Text(
                    '+',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('EE').containing(
                  const Text(
                    "  .-.-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('FF').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('GG').containing(
                  const Text(
                    "x",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('HH').containing(
                  const Text(
                    "  -..-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('II').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('LL').containing(
                  const Text(
                    ":",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('MM').containing(
                  const Text(
                    "  ---...",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('NN').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('AA1').containing(
                  const Text(
                    "=",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('BB1').containing(
                  const Text(
                    '  -...-',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('CC1').containing(
                  const Text(
                    '',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('DD1').containing(
                  const Text(
                    '"',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('EE1').containing(
                  const Text(
                    "  .-..-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('FF1').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('UU1').containing(
                  const Text(
                    ",",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('VV1').containing(
                  const Text(
                    "  --..--",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('ZZ1').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('GG1').containing(
                  const Text(
                    "'",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('HH1').containing(
                  const Text(
                    "  .----.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('II1').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('LL1').containing(
                  const Text(
                    ";",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('MM1').containing(
                  const Text(
                    "  -.-.-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('NN1').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('OO1').containing(
                  const Text(
                    "@",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('PP1').containing(
                  const Text(
                    "  .--.-.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('QQ1').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('RR1').containing(
                  const Text(
                    '\$',
                    style: TextStyle(fontSize: 16.0,
                    ),
                  ),
                ),
                gridArea('SS1').containing(
                  const Text(
                    "  ...-..-",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('TT1').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
/*
class CodeMorsePage extends StatelessWidget {
  const CodeMorsePage({super.key});

  // Funzione per aprire il menu laterale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Codice Morse'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline), // Icona per tornare indietro
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer( // Definizione del menu laterale
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox( // Riduzione dell'altezza del DrawerHeader
              height: 100, // Imposta l'altezza desiderata
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('     Web sites'),
              onTap: () {
                _launchUrl();
              },
            ),
            ListTile(
              title: const Text('     Privacy Policy'),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (context) => const TextPagePrivacy(text: ' ', pageTitle: 'Privacy Policy',),
                );
                Navigator.push(context, route);
              },
            ),
            ListTile(
              title: const Text('     Rate the app'),
              onTap: () {
                // Action to perform when "Mail address" is selected
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Contenuto della codemorse.dart'),
      ),
    );
  }
}*/
class TextPagePrivacy extends StatelessWidget {
  final String text;
  final String pageTitle; // Aggiunto il parametro per il titolo della pagina

  const TextPagePrivacy({Key? key, required this.text, required this.pageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: textPrivacy1,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                const TextSpan(
                  text: "\n\nApp Store\n\n",
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: textPrivacy2,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                TextSpan(
                  text: '\n\nhttps://policies.google.com',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchUrl1();
                    },
                ),
                const TextSpan(
                  text: "\n\nGDPR\n\n",
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: textPrivacy3,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                TextSpan(
                  text: '\n\nRegulation (EU) 2016/679 of the European Parliament and of the Council\n\n',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchUrl2();
                    },
                ),
                const TextSpan(
                  text: textPrivacy4,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                _buildEmailLinkSpan(),
                const TextSpan(
                  text: "\n\nMethod of collection and archiving of personal data\n\n",
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: textPrivacy5,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                const TextSpan(
                  text: "\n\nRequirement or obligation to provide data\n\n",
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: textPrivacy6,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                const TextSpan(
                  text: "\n\nDuration for which the personal data stored\n\n",
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: textPrivacy7,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                _buildEmailLinkSpan(),
                const TextSpan(
                  text: textPrivacy8,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                _buildEmailLinkSpan(),
                const TextSpan(
                  text: textPrivacy9,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                const TextSpan(
                  text: "\n\nThe following data may be processed by the supplier when using Morse Code App:\n\n",
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: textPrivacy10,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
TextSpan _buildEmailLinkSpan() {
  return TextSpan(
    text: 'stefanocavalli@outlook.com',
    style: const TextStyle(
      fontSize: 16.0,
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
    recognizer: TapGestureRecognizer()
      ..onTap = () {
        _sendEmail('stefanocavalli@outlook.com');
      },
  );
}
void _sendEmail(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
  );
  if (!await launchUrl(emailLaunchUri)) {
    throw Exception('Could not launch $emailLaunchUri');
  }
}
const String textPrivacy1 = """
This Privacy Statement explains what data is processed and how it is used.

By downloading, installing and using Morse Code you agree to have read, understood and accepted these Privacy Policy.""";

const String textPrivacy2 = """
By downloading the application from the Google Play Store, some statistics are collected that I can access, for example the State of provenance of the app download or the version of android installed on the device. 

Collecting or displaying personally identifiable data or other particular or sensitive data is not technically possible for me and not even in my interest.

For more information on the use of data by Google Inc. visit:""";

const String textPrivacy3 = """
The data protection policy complies with the provisions of the general EU data protection regulation (GDPR), which can be consulted at the web address:""";

const String textPrivacy4 = """ 
Contact details of the data protection officer: """;

const String textPrivacy5 = """
No personal data is stored.

By contacting me via e-mail, you consent to the processing of your personal data in accordance with the EU General Data Protection Regulation (GDPR).""";

const String textPrivacy6 = """
Unless otherwise expressly indicated, the provision of data is never required or mandatory.""";

const String textPrivacy7 = """The personal data sent to the e-mail address """;

const String textPrivacy8 = """ are kept in a form that allows the identification of the interested party and the subject matter for a period of time not exceeding that necessary for the purposes for which they are been collected or subsequently processed.

You can request the removal of your data at any time at this e-mail address: """;

const String textPrivacy9 = """ (data protection officer).""";

const String textPrivacy10 = """Some apps contain and can use third-party SDKs to use external services (such as Google, etc...). 

I have no influence on what data can be read and processed by these third parties. 

The app uses device identifiers to analyze their use. An assignation to your person or the identification of your device is neither in my interest nor technically possible for me.

In accordance with the GDPR only the data that are indispensable for the use of the App itself is automatically collected.
  
""";
