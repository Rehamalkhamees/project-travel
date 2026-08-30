import 'package:flutter/material.dart';
import '../models/destination_model.dart';

class DestinationPage extends StatelessWidget {
  final DestinationModel destination;

  const DestinationPage({
    super.key,
    required this.destination,
  });

  String getImageName() {
    switch (destination.name) {
      case 'Diriyah':
        return 'diriyah';
      case 'Riyadh':
        return 'riyadh';
      case 'AlUla':
        return 'alula';
      case 'Umluj':
        return 'umluj';
      case 'Abha':
        return 'abha';
      default:
        return 'riyadh';
    }
  }

  String getAboutText() {
    switch (destination.name) {
      case 'Diriyah':
        return 'Your bag is packed for a journey through Saudi Arabia’s history. '
            'Bring your curiosity and get ready to travel back in time. '
            'Diriyah is one of Saudi Arabia’s most important historical '
            'destinations and the birthplace of the first Saudi state. '
            'Explore At-Turaif, admire traditional Najdi architecture, and '
            'enjoy the atmosphere of Bujairi Terrace with its restaurants and cafés.';

      case 'Riyadh':
        return 'Your bag is ready for a vibrant city escape. Pack your best outfit '
            'and get ready for shopping, cafés, restaurants, and exciting entertainment. '
            'Riyadh combines modern city life with Saudi culture, offering something '
            'exciting for every visitor through its shopping destinations, stylish cafés, '
            'and seasonal events.';

      case 'AlUla':
        return 'Your bag is packed and adventure is calling. Bring your camera and '
            'comfortable shoes as you explore extraordinary desert landscapes and ancient history. '
            'AlUla is famous for its dramatic rock formations, Hegra, Elephant Rock, '
            'and Old Town, offering unforgettable moments surrounded by nature.';

      case 'Umluj':
        return 'Your bag is ready for a peaceful beach escape. Pack your essentials '
            'and get ready to enjoy clear water and relaxing views. Often called the '
            'Saudi Maldives, Umluj is known for its turquoise water, soft beaches, '
            'beautiful islands, and unforgettable Red Sea experiences.';

      case 'Abha':
        return 'Your bag is packed for a refreshing nature escape. Bring comfortable '
            'clothes and get ready for cool weather, mountains, and fresh air. '
            'Abha offers a completely different side of Saudi Arabia with green landscapes, '
            'scenic villages, breathtaking viewpoints, and the calm atmosphere of the Asir region.';

      default:
        return 'Pack your bag and discover a beautiful Saudi destination filled with '
            'unique experiences and unforgettable places.';
    }
  }

  List<String> getDiscoverItems() {
    switch (destination.name) {
      case 'Diriyah':
        return ['At-Turaif', 'Bujairi Terrace', 'Najdi Heritage'];
      case 'Riyadh':
        return ['Boulevard City', 'Via Riyadh', 'Kingdom Centre'];
      case 'AlUla':
        return ['Hegra', 'Elephant Rock', 'Old Town'];
      case 'Umluj':
        return ['Crystal Beaches', 'Island Trips', 'Snorkeling'];
      case 'Abha':
        return ['Rijal Almaa', 'Al-Soudah', 'Mountain Views'];
      default:
        return ['Explore', 'Discover', 'Enjoy'];
    }
  }

  List<IconData> getDiscoverIcons() {
    switch (destination.name) {
      case 'Diriyah':
        return [
          Icons.account_balance,
          Icons.restaurant,
          Icons.history_edu,
        ];

      case 'Riyadh':
        return [
          Icons.celebration,
          Icons.shopping_bag,
          Icons.location_city,
        ];

      case 'AlUla':
        return [
          Icons.account_balance,
          Icons.landscape,
          Icons.photo_camera,
        ];

      case 'Umluj':
        return [
          Icons.beach_access,
          Icons.directions_boat,
          Icons.scuba_diving,
        ];

      case 'Abha':
        return [
          Icons.home_work,
          Icons.terrain,
          Icons.visibility,
        ];

      default:
        return [
          Icons.explore,
          Icons.place,
          Icons.favorite,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageName = getImageName();
    final discoverItems = getDiscoverItems();
    final discoverIcons = getDiscoverIcons();

    return Scaffold(
      backgroundColor: const Color(0xFF26332F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF26332F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'SAUDI ESCAPE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 900 ? 100 : 25,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/${imageName}2.jpeg',
                  width: double.infinity,
                  height: screenWidth > 900 ? 430 : 280,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                destination.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                destination.type,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFFD7DED9),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFFF2C94C),
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '4.9',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '(2.4k traveler reviews)',
                    style: TextStyle(
                      color: Color(0xFFD7DED9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const Text(
                'ABOUT THE EXPERIENCE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                getAboutText(),
                style: const TextStyle(
                  color: Color(0xFFD7DED9),
                  fontSize: 16,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'DON’T MISS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == 2 ? 0 : 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFBF9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            discoverIcons[index],
                            color: const Color(0xFF35423E),
                            size: 28,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            discoverItems[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF35423E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (destination.color),
                    foregroundColor: const Color(0xFF26332F),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'BACK TO DESTINATIONS',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}