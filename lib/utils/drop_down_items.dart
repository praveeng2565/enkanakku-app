import '../widgets/custom_drop_down_field.dart';

List<DropDownItems> getExpenseCategories() {
  return const [
    DropDownItems(value: 'food', label: 'Food'),
    DropDownItems(value: 'groc', label: 'Groceries'),
    DropDownItems(value: 'trans', label: 'Transportation'),
    DropDownItems(value: 'enter', label: 'Entertainment'),
    DropDownItems(value: 'hosp', label: 'Hospital'),
    DropDownItems(value: 'edu', label: 'Education'),
    DropDownItems(value: 'shop', label: 'Shopping'),
    DropDownItems(value: 'gift', label: 'Gifts'),
    DropDownItems(value: 'othr', label: 'Others'),
  ];
}
