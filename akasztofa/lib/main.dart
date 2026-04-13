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
  int errors = 0; // Hibák száma (0-tól indul)
  final int maxErrors = 9;
  
  // Controller a teljes szó beírásához
  final TextEditingController _wordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    parsedWord = GameData.tokenizeWord(widget.word.toUpperCase());
  }

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  // Betű tipp kezelése
  void _onLetterPressed(String letter) {
    if (guessedLetters.contains(letter) || _isGameOver()) return;

    setState(() {
      guessedLetters.add(letter);
      if (!parsedWord.contains(letter)) {
        errors++;
      }
    });
  }

  // Teljes szó tipp kezelése
  void _handleFullWordGuess() {
    String guess = _wordController.text.trim().toUpperCase();
    if (guess.isEmpty || _isGameOver()) return;

    setState(() {
      if (guess == widget.word.toUpperCase()) {
        // Ha eltalálta, minden betűt felfedünk
        guessedLetters.addAll(parsedWord);
      } else {
        // Ha nem találta el, hiba nő
        errors++;
      }
      _wordController.clear(); // Mező ürítése
      FocusScope.of(context).unfocus(); // Billentyűzet bezárása
    });
  }

  bool _isGameWon() => parsedWord.every((letter) => guessedLetters.contains(letter));
  bool _isGameLost() => errors >= maxErrors;
  bool _isGameOver() => _isGameWon() || _isGameLost();

  void _restartGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TopicScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOver = _isGameOver();

    return Scaffold(
      appBar: AppBar(
        title: Text('Téma: ${widget.topic}'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        // SingleChildScrollView segít, ha a billentyűzet felugrik
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // --- AKASZTÓFA VIZUÁLIS MEGJELENÍTÉSE ---
              Center(
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: HangmanPainter(errors),
                ),
              ),

              // Hibaszámláló szövegesen
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Hibák: $errors / $maxErrors',
                  style: TextStyle(
                    color: errors > 6 ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // --- KITALÁLANDÓ SZÓ ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 12.0,
                  children: parsedWord.map((letter) {
                    bool isRevealed = guessedLetters.contains(letter) || _isGameLost();
                    return Container(
                      width: 35,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 2, color: Colors.teal)),
                      ),
                      child: Text(
                        isRevealed ? letter : '',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // --- TELJES SZÓ TIPPELESE ---
              if (!isOver)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _wordController,
                          decoration: const InputDecoration(
                            hintText: 'Egész szó tippelése...',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _handleFullWordGuess(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        onPressed: _handleFullWordGuess,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),

              // --- JÁTÉK VÉGE ÜZENET ---
              if (isOver) _buildGameOverUI(),

              // --- VIRTUÁLIS BILLENTYŰZET ---
              if (!isOver) _buildKeyboard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverUI() {
    bool isWon = _isGameWon();
    return Column(
      children: [
        Text(
          isWon ? '🎉 NYERTÉL!' : '💀 VESZTETTÉL!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isWon ? Colors.green : Colors.red),
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: _restartGame, child: const Text('Új játék')),
      ],
    );
  }

  Widget _buildKeyboard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4.0,
        runSpacing: 4.0,
        children: GameData.hungarianAlphabet.map((letter) {
          final isGuessed = guessedLetters.contains(letter);
          return GestureDetector(
            onTap: () => _onLetterPressed(letter),
            child: Container(
              width: 38,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isGuessed ? Colors.grey.shade300 : Colors.teal.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(letter, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class HangmanPainter extends CustomPainter {
  final int errorCount;

  HangmanPainter(this.errorCount);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // 1. hiba: Alap (vonal az alján)
    if (errorCount >= 1) {
      canvas.drawLine(Offset(size.width * 0.1, size.height * 0.9),
          Offset(size.width * 0.9, size.height * 0.9), paint);
    }
    // 2. hiba: Függőleges oszlop
    if (errorCount >= 2) {
      canvas.drawLine(Offset(size.width * 0.2, size.height * 0.9),
          Offset(size.width * 0.2, size.height * 0.1), paint);
    }
    // 3. hiba: Vízszintes gerenda és kötél
    if (errorCount >= 3) {
      canvas.drawLine(Offset(size.width * 0.2, size.height * 0.1),
          Offset(size.width * 0.6, size.height * 0.1), paint);
      canvas.drawLine(Offset(size.width * 0.6, size.height * 0.1),
          Offset(size.width * 0.6, size.height * 0.2), paint);
    }
    // 4. hiba: Fej
    if (errorCount >= 4) {
      canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.28), 20, paint);
    }
    // 5. hiba: Törzs
    if (errorCount >= 5) {
      canvas.drawLine(Offset(size.width * 0.6, size.height * 0.35),
          Offset(size.width * 0.6, size.height * 0.6), paint);
    }
    // 6. hiba: Bal kar
    if (errorCount >= 6) {
      canvas.drawLine(Offset(size.width * 0.6, size.height * 0.45),
          Offset(size.width * 0.45, size.height * 0.5), paint);
    }
    // 7. hiba: Jobb kar
    if (errorCount >= 7) {
      canvas.drawLine(Offset(size.width * 0.6, size.height * 0.45),
          Offset(size.width * 0.75, size.height * 0.5), paint);
    }
    // 8. hiba: Bal láb
    if (errorCount >= 8) {
      canvas.drawLine(Offset(size.width * 0.6, size.height * 0.6),
          Offset(size.width * 0.45, size.height * 0.8), paint);
    }
    // 9. hiba: Jobb láb
    if (errorCount >= 9) {
      canvas.drawLine(Offset(size.width * 0.6, size.height * 0.6),
          Offset(size.width * 0.75, size.height * 0.8), paint);
    }
  }

  @override
  bool shouldRepaint(covariant HangmanPainter oldDelegate) =>
      oldDelegate.errorCount != errorCount;
}