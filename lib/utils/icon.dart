import 'package:flutter/material.dart';

class UtilIcon {
  static IconData getIconData(String name) {
    switch (name) {
      case 'fas fa-shopping-bag':
      case 'shopping_basket':
        return Icons.shopping_basket;
      case 'fas fa-coffee':
      case 'local_drink':
        return Icons.local_drink;
      case 'fas fa-star':
      case 'event_available':
        return Icons.event_available;
      case 'fas fa-handshake':
      case 'all_inclusive':
        return Icons.all_inclusive;
      case 'fas fa-briefcase':
      case 'card_travel':
        return Icons.card_travel;
      case 'fas fa-utensil':
      case 'restaurant':
        return Icons.restaurant;
      case 'fas fa-car':
      case 'directions_car':
        return Icons.directions_car;
      case 'more_horiz':
        return Icons.more_horiz;
      case 'wifi':
        return Icons.wifi;
      case 'whatshot':
        return Icons.whatshot;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'pets':
        return Icons.pets;
      case 'access_time':
        return Icons.access_time;
      case 'sort':
        return Icons.sort;
      case "swap_vert":
        return Icons.swap_vert;
      case 'hotel':
        return Icons.hotel;
      case 'location_on':
        return Icons.location_on;
      case 'directions_car':
        return Icons.directions_car;
      case 'flight':
        return Icons.flight;
      case 'directions_boat':
        return Icons.directions_boat;
      case 'event':
        return Icons.event;
      case 'description':
        return Icons.description;

      default:
        return Icons.help;
    }
  }

  ///Singleton factory
  static final UtilIcon _instance = UtilIcon._internal();

  factory UtilIcon() {
    return _instance;
  }

  UtilIcon._internal();
}
