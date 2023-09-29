import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:torch_light/torch_light.dart';
import 'package:url_launcher/url_launcher.dart';
import 'codemorse.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

/* ----------------------------------------------------------------------------*/
// INIZIO CODICE PAGINA PRINCIPALE
/* ----------------------------------------------------------------------------*/

void main() {
  runApp(const TorchApp());
}

class TorchApp extends StatefulWidget {
  const TorchApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TorchAppState createState() => _TorchAppState();
}

class _TorchAppState extends State<TorchApp> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Color _containerColor = Colors.black;
  bool isColored = false;
  bool isCodeMorsePageOpen = true;
  bool isIconButtonPressed = false;
  bool isPrivacyPageOpen = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text('Morse Code converter'),
              actions: [
                IconButton(
                  icon: isIconButtonPressed
                      ? const Icon(Icons.home_outlined)
                      : const Icon(Icons.info_outline),
                  onPressed: () {
                    setState(() {
                      if (isIconButtonPressed) {
                        isCodeMorsePageOpen = true;
                        isIconButtonPressed = false;
                        isPrivacyPageOpen = false;
                      } else {
                        isCodeMorsePageOpen = false;
                        isIconButtonPressed = true;
                        isPrivacyPageOpen = false;
                      }
                    });
                  },
                ),
              ],
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
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox( // Riduzione dell'altezza del DrawerHeader
                    height: 100, // Imposta l'altezza desiderata
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        '  Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('    Rate App'),
                    onTap: () {
                      _launchUrl4();
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                  ListTile(
                    title: const Text('    Web sites'),
                    onTap: () {
                      _launchUrl();
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                  ListTile(
                    title: const Text('    Privacy Policy'),
                    onTap: () {
                      setState(() {
                        isPrivacyPageOpen = true;
                        isCodeMorsePageOpen = false;
                        isIconButtonPressed = true;
                      });
                      // Chiude il Drawer utilizzando la chiave global _scaffoldKey
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                  ListTile(
                    title: const Text('    Download Photo Comics Lab'),
                    onTap: () {
                      _launchUrl3();
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                ],
              ),
            ),
            body: isPrivacyPageOpen
                ? const TextPagePrivacy(text: '', pageTitle: 'Privacy Policy',) : isCodeMorsePageOpen ? FutureBuilder<bool>(
              future: _isTorchAvailable(context),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  return Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Align(
                          alignment: const FractionalOffset(0.5, 0.5),
                          child: GestureDetector(
                            onTapDown: (_) {
                              _enableTorch(context);
                            },
                            onTapUp: (_) {
                              _disableTorch(context);
                            },
                            child: Container(
                              width: 200,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: _containerColor,
                              ),
                              child: Icon(
                                Icons.highlight_outlined,
                                size: 50,
                                color: isColored ? const Color(0xFF000000) : const Color(0xFFFFFF00),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Flexible(
                        flex:4,
                        child: MorseScreen(),
                      ),
                    ],
                  );
                } else if (snapshot.hasData) {
                  return const Center(
                    child: Text('No torch available.'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ) : const CodeMorsePage()
        ));
  }

  Future<bool> _isTorchAvailable(BuildContext context) async {
    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      _showMessage(
        'Could not check if the device has an available torch',
        context,
      );
      rethrow;
    }
  }

  Future<void> _enableTorch(BuildContext context) async {
    try {
      await TorchLight.enableTorch();
      setState(() {
        _containerColor = Colors.yellowAccent;
        isColored = true;
      });

    } on Exception catch (_) {
      _showMessage('Could not enable torch', context);
    }
  }

  Future<void> _disableTorch(BuildContext context) async {
    try {
      await TorchLight.disableTorch();
      setState(() {
        _containerColor = Colors.black;
        isColored = false;
      });
    } on Exception catch (_) {
      _showMessage('Could not disable torch', context);
    }
  }

  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

/* ----------------------------------------------------------------------------*/
// FINE CODICE PAGINA PRINCIPALE
/* ----------------------------------------------------------------------------*/

/* ----------------------------------------------------------------------------*/
// INIZIO CODICE CLASSE MORSE SCREEN 
/* ----------------------------------------------------------------------------*/

class MorseScreen extends StatefulWidget {
  const MorseScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MorseScreenState createState() => _MorseScreenState();
}

class _MorseScreenState extends State<MorseScreen> {
  String inputText = '';
  String morseCode = '';
  String decodedText = '';

  void convertToMorse() {
    setState(() {
      morseCode = textToMorse(inputText);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter words separated by spaces.',
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Input Text (50 characters)',
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
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Result after conversion:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
              morseCode.isNotEmpty ? 'the character / indicates the beginning of a new word' : '',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            //const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            Text(
              morseCode.isNotEmpty ? ' $morseCode ' : '',
              style:
              const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            LayoutGrid(
              areas: '''
              OO PP
              A B
              QQ RR
              UU VV
              ZZ K2
              K3 K4
              SS TT
              ''',
              columnSizes: [170.px, 100.px],
              rowSizes: [
                22.px,
                26.px,
                30.px,
                30.px,
                30.px,
                30.px,
                30.px
              ],
              columnGap: 2,
              rowGap: 0,
              children: [
                gridArea('A').containing(
                  const Text(
                    "to precede every trasmission",
                    style: TextStyle(fontSize: 12.0
                    ),
                  ),
                ),
                gridArea('B').containing(
                  const Text(
                    "",
                    style: TextStyle(fontSize: 12.0
                    ),
                  ),
                ),
                gridArea('OO').containing(
                  const Text(
                    "Starting signal: ",
                    style: TextStyle(fontSize: 16.0
                    ),
                  ),
                ),
                gridArea('PP').containing(
                  const Text(
                    '-.-.-',
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('QQ').containing(
                  const Text(
                    'End of work: ',
                    style: TextStyle(fontSize: 16.0
                    ),
                  ),
                ),
                gridArea('RR').containing(
                  const Text(
                    "...-.-",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('SS').containing(
                  const Text(
                    "Error (eight dots): ",
                    style: TextStyle(fontSize: 16.0
                    ),
                  ),
                ),
                gridArea('TT').containing(
                  const Text(
                    "........",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('UU').containing(
                  const Text(
                    "Wait: ",
                    style: TextStyle(fontSize: 16.0
                    ),
                  ),
                ),
                gridArea('VV').containing(
                  const Text(
                    ".-...",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('ZZ').containing(
                  const Text(
                    "Understood: ",
                    style: TextStyle(fontSize: 16.0
                    ),
                  ),
                ),
                gridArea('K2').containing(
                  const Text(
                    "...-.",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gridArea('K3').containing(
                  const Text(
                    "Stop (period): ",
                    style: TextStyle(fontSize: 16.0
                    ),
                  ),
                ),
                gridArea('K4').containing(
                  const Text(
                    ".-.-.-",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,
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

/* ----------------------------------------------------------------------------*/
// FINE CODICE CLASSE MORSE SCREEN
/* ----------------------------------------------------------------------------*/

/* ----------------------------------------------------------------------------*/
// INIZIO CODICE MENU LATERALE LINK ESTERNI
/* ----------------------------------------------------------------------------*/

final Uri _url = Uri.parse('https://sites.google.com/view/stefanocavalli/home');
final Uri _url3 = Uri.parse('https://play.google.com/store/apps/details?id=com.stecavalliofficial.PhotoComicsLab');
final Uri _url4 = Uri.parse('market://details?id=com.stefanocavalli.cod_morse');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
Future<void> _launchUrl3() async {
  if (!await launchUrl(_url3)) {
    throw Exception('Could not launch $_url3');
  }
}
Future<void> _launchUrl4() async {
  if (!await launchUrl(_url4)) {
    throw Exception('Could not launch $_url4');
  }
}

/* ----------------------------------------------------------------------------*/
// INIZIO CODICE MENU LATERALE LINK ESTERNI
/* ----------------------------------------------------------------------------*/

/* ----------------------------------------------------------------------------*/
// INIZIO CODICE PAGINA PRIVACY POLICY
/* ----------------------------------------------------------------------------*/

final Uri _url1 = Uri.parse('https://policies.google.com');
final Uri _url2 = Uri.parse('https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504');

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

/* ----------------------------------------------------------------------------*/
// FINE CODICE PAGINA PRIVACY POLICY
/* ----------------------------------------------------------------------------*/
