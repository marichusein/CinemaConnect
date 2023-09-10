import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final Function(String) onCategorySelected;

  const Category({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int selectedCategory = 0;
  List<String> categories = ["Trenutno u kinu", "Novosti", "Preporuka"];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 0.0),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => buildCategory(index, context),
      ),
    );
  }

  Padding buildCategory(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = index;
          });
          widget.onCategorySelected(categories[index]);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SFUIText',
                    color: index == selectedCategory
                        ? Colors.black
                        : Color.fromARGB(105, 45, 45, 45),
                  ),
            ),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: index == selectedCategory
                    ? Color.fromARGB(255, 207, 185, 57)
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
