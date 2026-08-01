import '../widgets/custom_drop_down_field.dart';

List<DropDownItems> getExpenseCategories() {
  return const [
    DropDownItems(value: '0', label: 'Food'),
    DropDownItems(value: '1', label: 'Groceries'),
    DropDownItems(value: '2', label: 'Transportation'),
    DropDownItems(value: '3', label: 'Entertainment'),
    DropDownItems(value: '4', label: 'Hospital'),
    DropDownItems(value: '5', label: 'Education'),
    DropDownItems(value: '6', label: 'Shopping'),
    DropDownItems(value: '7', label: 'Gifts'),
    DropDownItems(value: '8', label: 'Others'),
  ];
}
