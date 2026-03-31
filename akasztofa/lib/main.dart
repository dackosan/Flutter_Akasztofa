import 'package:flutter/material.dart';

void main() {
  runApp(const HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magyar Akasztófa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const TopicScreen(),
    );
  }
}

/// --- ADATBÁZIS ÉS LOGIKA ---

class GameData {
  static const Map<String, List<String>> topics = {
    'Ételek': [
      'KENYÉR',
      'PÖRKÖLT',
      'GULYÁS',
      'PALACSINTA',
      'LÁNGOS',
      'HALÁSZLÉ',
      'RÁNTOTTA',
      'KOLBÁSZ',
      'HURKA',
      'SZALONNA',
      'TÚRÓRUDI',
      'PAPRIKÁS',
      'SOMLÓI',
      'RÉTES',
      'POGÁCSA',
      'KIFLI',
      'ZSEMLE',
      'SZILVÁSGOMBÓC',
      'BEJGLI',
      'LECSÓ',
    ],
    'Eszközök': [
      'KALAPÁCS',
      'FŰRÉSZ',
      'CSAVARHÚZÓ',
      'FOGÓ',
      'FÚRÓGÉP',
      'ECSET',
      'BALTA',
      'ÁSÓ',
      'LAPÁT',
      'GEREBLYE',
      'CSAVARKULCS',
      'MÉRŐSZALAG',
      'VÉSŐ',
      'RESZELŐ',
      'TALICSKA',
      'SEPRŰ',
      'VASVILLA',
      'METSZŐOLLÓ',
      'HARAPÓFOGÓ',
      'SATU',
    ],
    'Tantárgyak': [
      'MATEMATIKA',
      'MAGYAR',
      'TÖRTÉNELEM',
      'FIZIKA',
      'KÉMIA',
      'BIOLÓGIA',
      'FÖLDRAJZ',
      'TESTNEVELÉS',
      'INFORMATIKA',
      'ÉNEK',
      'RAJZ',
      'TECHNIKA',
      'IRODALOM',
      'NYELVTAN',
      'ETIKA',
      'FILOZÓFIA',
      'DRÁMA',
      'MŰVÉSZETTÖRTÉNET',
      'HITTAN',
      'TÁRSADALOMISMERET',
    ],
    'Sportok': [
      'LABDARÚGÁS',
      'KOSÁRLABDA',
      'KÉZILABDA',
      'VÍZILABDA',
      'RÖPLABDA',
      'TENISZ',
      'ASZTALITENISZ',
      'ÚSZÁS',
      'JÉGKORONG',
      'VÍVÁS',
      'ATLÉTIKA',
      'TORNA',
      'BIRKÓZÁS',
      'CSELGÁNCS',
      'ÖKÖLVÍVÁS',
      'KAJAK',
      'KENU',
      'EVEZÉS',
      'LOVAGLÁS',
      'KERÉKPÁROZÁS',
    ],
    'Növények': [
      'TÖLGYFA',
      'BÜKKFA',
      'FENYŐFA',
      'RÓZSA',
      'TULIPÁN',
      'NÁRCISZ',
      'HÓVIRÁG',
      'PITYPANG',
      'MUSKÁTLI',
      'ORCHIDEA',
      'NAPRAFORGÓ',
      'BÚZA',
      'KUKORICA',
      'KRUMPLI',
      'PARADICSOM',
      'PAPRIKA',
      'ALMAFA',
      'KÖRTEFA',
      'SZILVAFA',
      'CSERESZNYEFA',
    ],
    'Állatok': [
      'KUTYA',
      'MACSKA',
      'LÓ',
      'TEHÉN',
      'DISZNÓ',
      'BIRKA',
      'KECSKE',
      'TYÚK',
      'KACSA',
      'LIBA',
      'OROSZLÁN',
      'TIGRIS',
      'MEDVE',
      'FARKAS',
      'RÓKA',
      'SZARVAS',
      'ŐZ',
      'VADDISZNÓ',
      'NYÚL',
      'MÓKUS',
    ],
    'Országok': [
      'MAGYARORSZÁG',
      'NÉMETORSZÁG',
      'AUSZTRIA',
      'SZLOVÁKIA',
      'ROMÁNIA',
      'SZERBIA',
      'HORVÁTORSZÁG',
      'SZLOVÉNIA',
      'OLASZORSZÁG',
      'FRANCIAORSZÁG',
      'SPANYOLORSZÁG',
      'EGYESÜLTKIRÁLYSÁG',
      'SVÉDORSZÁG',
      'NORVÉGIA',
      'FINNORSZÁG',
      'OROSZORSZÁG',
      'KÍNA',
      'JAPÁN',
      'EGYESÜLTÁLLAMOK',
      'KANADA',
    ],
  };

  static const List<String> hungarianAlphabet = [
    'A',
    'Á',
    'B',
    'C',
    'CS',
    'D',
    'DZ',
    'DZS',
    'E',
    'É',
    'F',
    'G',
    'GY',
    'H',
    'I',
    'Í',
    'J',
    'K',
    'L',
    'LY',
    'M',
    'N',
    'NY',
    'O',
    'Ó',
    'Ö',
    'Ő',
    'P',
    'Q',
    'R',
    'S',
    'SZ',
    'T',
    'TY',
    'U',
    'Ú',
    'Ü',
    'Ű',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    'ZS',
  ];

  /// Speciális függvény, ami a magyar szavakat helyesen bontja betűkre,
  /// figyelembe véve a többjegyű mássalhangzókat.
  static List<String> tokenizeWord(String word) {
    List<String> result = [];
    int i = 0;
    while (i < word.length) {
      if (i + 2 < word.length && word.substring(i, i + 3) == 'DZS') {
        result.add('DZS');
        i += 3;
      } else if (i + 1 < word.length) {
        String digraph = word.substring(i, i + 2);
        if ([
          'CS',
          'DZ',
          'GY',
          'LY',
          'NY',
          'SZ',
          'TY',
          'ZS',
        ].contains(digraph)) {
          result.add(digraph);
          i += 2;
        } else {
          result.add(word[i]);
          i++;
        }
      } else {
        result.add(word[i]);
        i++;
      }
    }
    return result;
  }
}

/// --- TÉMAVÁLASZTÓ KÉPERNYŐ ---

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Válassz témát!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: GameData.topics.keys.length,
            itemBuilder: (context, index) {
              String topic = GameData.topics.keys.elementAt(index);
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                ),
                onPressed: () {
                  // Téma kiválasztása, szó sorsolása és navigáció
                  final words = List<String>.from(
                    GameData.topics[topic]!,
                  ); // Itt készítünk egy módosítható másolatot
                  words.shuffle();
                  final selectedWord = words.first;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GameScreen(topic: topic, word: selectedWord),
                    ),
                  );
                },
                child: Text(
                  topic,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// --- JÁTÉK KÉPERNYŐ ---

class GameScreen extends StatefulWidget {
  final String topic;
  final String word;

  const GameScreen({super.key, required this.topic, required this.word});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> parsedWord;
  Set<String> guessedLetters = {};
  int lives = 5;

  @override
  void initState() {
    super.initState();
    // A kiválasztott szót betűkre (elemekre) bontjuk a játék indulásakor
    parsedWord = GameData.tokenizeWord(widget.word);
  }

  void _onLetterPressed(String letter) {
    if (guessedLetters.contains(letter) || _isGameOver()) return;

    setState(() {
      guessedLetters.add(letter);
      if (!parsedWord.contains(letter)) {
        lives--;
      }
    });
  }

  bool _isGameWon() {
    return parsedWord.every((letter) => guessedLetters.contains(letter));
  }

  bool _isGameLost() {
    return lives <= 0;
  }

  bool _isGameOver() {
    return _isGameWon() || _isGameLost();
  }

  void _restartGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TopicScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWon = _isGameWon();
    final bool isLost = _isGameLost();
    final bool isOver = isWon || isLost;

    return Scaffold(
      appBar: AppBar(
        title: Text('Téma: ${widget.topic}'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _restartGame,
            tooltip: 'Témaválasztó',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Életek kijelzése
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      index < lives ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey<bool>(index < lives),
                      color: Colors.red,
                      size: 36,
                    ),
                  );
                }),
              ),
            ),

            // Kitalálandó szó kijelzése
            Expanded(
              flex: 2,
              child: Center(
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 12.0,
                    children: parsedWord.map((letter) {
                      bool isRevealed =
                          guessedLetters.contains(letter) || isLost;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 45,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isRevealed
                              ? (isLost && !guessedLetters.contains(letter)
                                    ? Colors.red.shade100
                                    : Colors.teal.shade50)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isRevealed
                                ? Colors.teal
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          isRevealed ? letter : '_',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isLost && !guessedLetters.contains(letter)
                                ? Colors.red
                                : Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Játék vége üzenet és gomb
            if (isOver)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      isWon ? '🎉 NYERTÉL! 🎉' : '💀 VESZTETTÉL! 💀',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isWon ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _restartGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'Új játék',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Virtuális billentyűzet (Magyar ábécé)
            Expanded(
              flex: 3,
              child: IgnorePointer(
                ignoring: isOver, // Ha vége a játéknak, ne lehessen kattintani
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: GameData.hungarianAlphabet.map((letter) {
                      final isGuessed = guessedLetters.contains(letter);
                      final isCorrect =
                          isGuessed && parsedWord.contains(letter);
                      final isWrong = isGuessed && !parsedWord.contains(letter);

                      Color bgColor = Theme.of(
                        context,
                      ).colorScheme.surfaceVariant;
                      Color textColor = Colors.black87;

                      if (isCorrect) {
                        bgColor = Colors.green;
                        textColor = Colors.white;
                      } else if (isWrong) {
                        bgColor = Colors.red;
                        textColor = Colors.white;
                      }

                      return GestureDetector(
                        onTap: () => _onLetterPressed(letter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 40,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: isGuessed
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 2,
                                      offset: const Offset(1, 2),
                                    ),
                                  ],
                          ),
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
