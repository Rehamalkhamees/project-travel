import 'package:flutter/material.dart';
import 'package:travel_project5/models/destination_model.dart';

/// Sample rows shaped like the `destinationData` table, used by the offline
/// demo mode and by the tests.
final demoDestinations = <DestinationModel>[
  DestinationModel(
    name: 'Diriyah',
    type: 'Heritage',
    image: 'assets/images/diriyah2.jpeg',
    color: const Color(0xFFE3A872),
  ),
  DestinationModel(
    name: 'Riyadh',
    type: 'City',
    image: 'assets/images/riyadh1.jpeg',
    color: const Color(0xFF8CC0D6),
  ),
  DestinationModel(
    name: 'AlUla',
    type: 'Adventure',
    image: 'assets/images/alula2.jpeg',
    color: const Color(0xFFEB9C63),
  ),
  DestinationModel(
    name: 'Umluj',
    type: 'Beach',
    image: 'assets/images/umluj1.jpeg',
    color: const Color(0xFF63CFC8),
  ),
  DestinationModel(
    name: 'Abha',
    type: 'Nature',
    image: 'assets/images/abha1.jpeg',
    color: const Color(0xFF9CCB78),
  ),
];
