import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/screens/account_settings.dart';
import 'package:login/screens/show_orders.dart';
import 'package:login/screens/welcome_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.docID});

  final String title = "BAELG";
  final String docID;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  double walletBalance = 200; // Initial wallet balance
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  void accountSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AccountSettings(docID: widget.docID)),
    );
  }

  late CollectionReference usersCollection;

  @override
  void initState() {
    usersCollection = FirebaseFirestore.instance.collection('Users');
    fetchData();

    super.initState();

    // Initialize Firebase Firestore
  }

  void fetchData() async {
    try {
      // Fetch user data using docID
      DocumentSnapshot userDoc = await usersCollection.doc(widget.docID).get();

      // Retrieve specific fields like username, password, balance
      //eto dapat

      String username = userDoc.get('username');
      String password = userDoc.get('password');
      double balance = (userDoc.get('balance') ?? 0).toDouble();
      String docID = userDoc.id;

      setState(() {
        walletBalance = balance;
      }); // Update walletBalance with fetched data

      print(walletBalance);
    } catch (e) {
      print("Error fetching data: $e");
      // Handle errors if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: Text(widget.title),
          actions: [
            Container(), // This container replaces the second sidebar in the app bar
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.docID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                var userDoc = snapshot.data!;
                String username = userDoc.get('username');
                String password = userDoc.get('password');
                double balance = (userDoc.get('balance') ?? 0).toDouble();
                String docID = userDoc.id;

                return HomePageContent(walletBalance: balance);
              } else {
                return Center(child: Text('No data available'));
              }
            }
          }),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              height: 150,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  height: 140,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 60,
                      backgroundImage: AssetImage(
                        'assets/2.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Homepage'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Orders'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowOrders(docID: widget.docID)),
                );
              },
            ),
            ListTile(
              title: const Text('Account Settings'),
              selected: _selectedIndex == 1,
              onTap: () {
                accountSettings();
              },
            ),
            ListTile(
              title: const Text('Logout'),
              selected: _selectedIndex == 1,
              onTap: () {
                _logout();
              },
            ),
            // ... The rest of your options
          ],
        ),
      ),
    );
  }

  List<Widget> _widgetOptions = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (walletBalance != null) {
      _widgetOptions = <Widget>[
        HomePageContent(
            walletBalance: walletBalance), // Pass walletBalance when available
        // ... The rest of your options
      ];
    }
  }
}

class HomePageContent extends StatefulWidget {
  HomePageContent({Key? key, required this.walletBalance, this.docID})
      : super(key: key);
  final double walletBalance;
  final String? docID;

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final List<String> ulamImageAssetPaths = [
    'assets/2.png',
    'assets/2.png',
    'assets/2.png',
    'assets/2.png',
    // Add more ulam asset paths here
  ];

  final List<String> categoryImageAssetPaths = [
    'assets/2.png',
    'assets/2.png',
    'assets/2.png',
    'assets/2.png',
    'assets/2.png',
    // Add more category asset paths here
  ];

  final List<String> categoryNames = [
    'Meat',
    'Vegetables',
    'Seafood',
    'Dairy-free',
    'Bading',
    // Add more category names here
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          // margin between appbar and others
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Magandang Hapon, User!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          // distance between welcome user and rest of page
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.black,
                  size: 42,
                ),
              ),
              SizedBox(width: 20), // distance between balance and wallet icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Balance',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\$${widget.walletBalance}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 36),
          // distance between wallet balance and carousel
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ulams to try today!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          // distance between ulams to try today and carousel
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
            ),
            items: ulamImageAssetPaths.asMap().entries.map((entry) {
              final assetPath = entry.value;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // distance between carousel and category text
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          // distance between category text and image widgets
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0, // added spacing between images
            children: categoryImageAssetPaths.asMap().entries.map((entry) {
              final index = entry.key;
              final assetPath = entry.value;
              final imageSize = index == 0
                  ? 420.0
                  : 200.0; // Adjust the size for the first image
              return GestureDetector(
                onTap: () {
                  _showCategorySlider(context, categoryNames[index]);
                },
                child: _buildCategoryImage(
                    assetPath, categoryNames[index], imageSize),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryImage(String imagePath, String text, double imageSize) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: imageSize,
                height: 150,
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void _showCategorySlider(BuildContext context, String categoryName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 700.0, // Set the desired height of your slider
          color: Colors.white,
          child: Center(
            child: Text(
              'Slider for $categoryName',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
      },
    );
  }
}
