import 'package:flutter/material.dart';
import 'package:travel_project5/service/database.dart';

import '../models/destination_model.dart';
import 'destination_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

  List<DestinationModel> destinations = [];

  List<DestinationModel> filteredDestinations = [];

  void searchDestination(String value) {
    setState(() {
      filteredDestinations = destinations.where((destination) {
       return destination.name.toString().toLowerCase().contains(
          value.toLowerCase(),
        );
     }).toList();
   });
  }
 TextEditingController nameController = TextEditingController();
 TextEditingController typeController = TextEditingController();
 TextEditingController ImageController = TextEditingController();
 TextEditingController colorController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
     typeController.dispose();
      ImageController.dispose();
      colorController.dispose();
     searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF26332F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 35),

              const Text(
                'Your Bag, Your Destination',
                style: TextStyle(
                  color: Color(0xFFD7DED9),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'YOUR BAG DECIDES\nYOUR DESTINATION',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Pack your essentials. Pick your journey.\n'
                'Let your bag choose where Saudi Arabia takes you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD7DED9),
                  fontSize: 17,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: screenWidth > 700 ? 420 : screenWidth * 0.8,
                child: TextField(
                  controller: searchController,
                  onChanged: searchDestination,
                  style: const TextStyle(color: Color(0xFF26332F)),
                  decoration: InputDecoration(
                    hintText: 'Search a destination...',
                    hintStyle: const TextStyle(color: Color(0xFF6B7470)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF6B7470),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF4F5F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'WHAT IS IN YOUR BAG?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 420,
                child: FutureBuilder(
                  future: Database().getAlltravel(), //newww
                  builder: (context, asyncSnapshot) {
                    print(asyncSnapshot.data);
                    if (!asyncSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth > 700 ? 60 : 20,
                      ),
                      itemCount: asyncSnapshot.data!.length, //newww
                      itemBuilder: (context, index) {
                        final destination = asyncSnapshot.data![index]; //newww

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DestinationPage(destination: destination),
                              ),
                            );
                          },
                          child: Container(
                            width: 250,
                            margin: const EdgeInsets.only(right: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    destination.image,
                                    fit: BoxFit.cover,
                                  ),

                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Color(0xCC000000),
                                        ],
                                        stops: [0.4, 1],
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    left: 22,
                                    right: 22,
                                    bottom: 24,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          destination.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          destination.type,
                                          style: const TextStyle(
                                            color: Color(0xFFE3E7E4),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        const SizedBox(height: 18),

                                        const Text(
                                          'Discover →',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Choose a destination and discover its story.',
                style: TextStyle(color: Color(0xFFD7DED9), fontSize: 16),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.green,
  child: Icon(Icons.add,size: 34,color: Colors.white,),
  
  onPressed: (){
showDialog(
  context: context,

 builder: (context){
return Dialog(
child: Container(
margin: EdgeInsets.all(18),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Text("add new distince")
AppSize.h24,
TextField(
controller: nameController,
decoration: InputDecoration(
labelText: "name",
border: OutlineInputBorder()
),
),
AppSize.h24,
TextField(


  
)






],

),
),

);


 }
 
 
 
 
 );



  }


),


    );
  }
}
