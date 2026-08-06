import '../widgets/custom_drop_down_field.dart';

List<DropDownItems> getExpenseCategories() {
  return const [
    DropDownItems(value: '0', label: 'Food'),
    DropDownItems(value: '1', label: 'Groceries'),
    DropDownItems(value: '2', label: 'Transportation'),
    DropDownItems(value: '3', label: 'EMI'),
    DropDownItems(value: '4', label: 'Entertainment'),
    DropDownItems(value: '5', label: 'Hospital'),
    DropDownItems(value: '6', label: 'Education'),
    DropDownItems(value: '7', label: 'Shopping'),
    DropDownItems(value: '8', label: 'House Rent'),
    DropDownItems(value: '9', label: 'Electricity'),
    DropDownItems(value: '10', label: 'Others'),
  ];
}
