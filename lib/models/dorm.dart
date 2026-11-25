enum RoomStatus { available, limited, full }

class Room {
  final String name;
  final String capacityLabel; // e.g. "4 pax Bedspace", "Solo Room"
  final int price;
  final int availableSlots;
  final int totalSlots;
  final RoomStatus status;

  const Room({
    required this.name,
    required this.capacityLabel,
    required this.price,
    required this.availableSlots,
    required this.totalSlots,
    required this.status,
  });

  String get badgeLabel {
    if (status == RoomStatus.full) return 'Full';
    return totalSlots > 1 ? '$availableSlots/$totalSlots Available' : 'Available';
  }
}

class Dorm {
  final String name;
  final String address;
  final int price; // pesos per month
  final String roomType;
  final String? image; // asset path, optional
  final String description;
  final int slotsAvailable;
  final String hostName;
  final bool isVerifiedHost;
  final List<String> inclusions;
  final List<Room> rooms;

  const Dorm({
    required this.name,
    required this.address,
    required this.price,
    required this.roomType,
    this.image,
    this.description = '',
    this.slotsAvailable = 0,
    this.hostName = 'Dorm Owner',
    this.isVerifiedHost = false,
    this.inclusions = const [],
    this.rooms = const [],
  });
}

const sampleDorms = <Dorm>[
  Dorm(
    name: 'Happy House Dorm',
    address: 'Mars Street, Golden Country Homes (GCH)',
    price: 3200,
    roomType: 'Bedspace',
    image: 'assets/images/dorm1.jpg',
    description: 'A quiet dorm a short walk from BatStateU Alangilan.',
    slotsAvailable: 2,
    hostName: 'Edmar Visto',
    isVerifiedHost: true,
    inclusions: [
      'Air conditioned Rooms',
      '24/7 CCTV',
      'A quiet Study Area',
      'WIFI 150 Mbps',
    ],
    rooms: [
      Room(
        name: 'Happy House - Room 101',
        capacityLabel: '4 pax Bedspace',
        price: 3200,
        availableSlots: 1,
        totalSlots: 4,
        status: RoomStatus.available,
      ),
      Room(
        name: 'Happy House - Room 102',
        capacityLabel: '4 pax Bedspace',
        price: 3200,
        availableSlots: 1,
        totalSlots: 4,
        status: RoomStatus.limited,
      ),
      Room(
        name: 'Happy House - Room 103',
        capacityLabel: 'Solo Room',
        price: 4500,
        availableSlots: 1,
        totalSlots: 1,
        status: RoomStatus.available,
      ),
    ],
  ),
  Dorm(
    name: 'Happy House Dorm',
    address: 'Mars Street, Golden Country Homes (GCH)',
    price: 2800,
    roomType: 'Shared',
    image: 'assets/images/dorm2.jpg',
    description: 'Affordable shared rooms with a common kitchen.',
    slotsAvailable: 3,
    hostName: 'Maria Santos',
    isVerifiedHost: true,
    inclusions: [
      'Electric Fan',
      'Shared Kitchen',
      'WIFI 100 Mbps',
      'Laundry Area',
    ],
    rooms: [
      Room(
        name: 'Happy House - Room 201',
        capacityLabel: '2 pax Shared',
        price: 2800,
        availableSlots: 2,
        totalSlots: 2,
        status: RoomStatus.available,
      ),
      Room(
        name: 'Happy House - Room 202',
        capacityLabel: '3 pax Shared',
        price: 2500,
        availableSlots: 1,
        totalSlots: 3,
        status: RoomStatus.limited,
      ),
    ],
  ),
  Dorm(
    name: 'Happy House Dorm',
    address: 'Mars Street, Golden Country Homes (GCH)',
    price: 4500,
    roomType: 'Single',
    image: 'assets/images/dorm3.jpg',
    description: 'Private single rooms with your own comfort room.',
    slotsAvailable: 0,
    hostName: 'Ramon Dela Cruz',
    isVerifiedHost: false,
    inclusions: [
      'Air conditioned Rooms',
      'Private Bathroom',
      '24/7 CCTV',
      'WIFI 200 Mbps',
    ],
    rooms: [
      Room(
        name: 'Happy House - Room 301',
        capacityLabel: 'Solo Room',
        price: 4500,
        availableSlots: 0,
        totalSlots: 1,
        status: RoomStatus.full,
      ),
      Room(
        name: 'Happy House - Room 302',
        capacityLabel: 'Solo Room',
        price: 4800,
        availableSlots: 1,
        totalSlots: 1,
        status: RoomStatus.available,
      ),
    ],
  ),
];
