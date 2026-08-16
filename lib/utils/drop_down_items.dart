import 'package:flutter/material.dart';
import '../widgets/custom_drop_down_field.dart';

List<DropDownItems> getExpenseCategories() {
  return const [
    DropDownItems(value: '0', label: 'Food', icon: Icons.restaurant_rounded),
    DropDownItems(
      value: '1',
      label: 'Groceries',
      icon: Icons.shopping_cart_rounded,
    ),
    DropDownItems(
      value: '2',
      label: 'Travel',
      icon: Icons.directions_car_rounded,
    ),
    DropDownItems(value: '3', label: 'Bills', icon: Icons.receipt_long_rounded),
    DropDownItems(
      value: '4',
      label: 'EMI & Loans',
      icon: Icons.account_balance_rounded,
    ),
    DropDownItems(
      value: '5',
      label: 'Shopping',
      icon: Icons.shopping_bag_rounded,
    ),
    DropDownItems(value: '6', label: 'Health', icon: Icons.favorite_rounded),
    DropDownItems(value: '7', label: 'Education', icon: Icons.school_rounded),
    DropDownItems(
      value: '8',
      label: 'Entertainment',
      icon: Icons.school_rounded,
    ),
    DropDownItems(value: '9', label: 'Others', icon: Icons.category_rounded),
  ];
}
