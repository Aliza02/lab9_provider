import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var movies = context.watch<MovieProvider>().movies;
    var fvr8List = context.watch<MovieProvider>().myList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider example'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyListPage()));
            },
            child: const Text(
              'Go to My list',
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: movies.length,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(movies[index].title),
            subtitle: Text(movies[index].runTime ?? 'No information.'),
            trailing: IconButton(
              onPressed: () {
                context.read<MovieProvider>().addToList(movies[index]);
              },
              icon: Icon(
                Icons.favorite,
                color:
                    fvr8List.contains(movies[index]) ? Colors.red : Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key}) : super(key: key);

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  @override
  Widget build(BuildContext context) {
    var fvr8List = context.watch<MovieProvider>().myList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
      ),
      body: ListView.builder(
        itemCount: fvr8List.length,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(fvr8List[index].title),
            subtitle: Text(fvr8List[index].runTime ?? 'No information.'),
            trailing: TextButton(
              onPressed: () {
                context.read<MovieProvider>().removeFromList(fvr8List[index]);
              },
              child: const Text(
                'Remove',
              ),
            ),
          );
        },
      ),
    );
  }
}

final List<Movie> initialData = List.generate(
  50,
  (index) => Movie(
    title: 'Movie #${index + 1}',
    runTime: '${Random().nextInt(100) + 60} minutes',
  ),
);

class MovieProvider with ChangeNotifier {
  final List<Movie> _movies = initialData;
  final List<Movie> _myList = [];
  List<Movie> get movies => _movies;
  List<Movie> get myList => _myList;

  void addToList(Movie movie) {
    _myList.add(movie);
    notifyListeners();
  }

  void removeFromList(Movie movie) {
    _myList.remove(movie);
    notifyListeners();
  }
}

class Movie {
  final String title;
  final String? runTime;

  Movie({required this.title, this.runTime});
}
