import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultButton(
        {required Function()? fun,
        required Color color,
        required String text}) =>
    Container(
      width: double.infinity,
      color: color,
      child: MaterialButton(
        onPressed: fun,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultTextField({
  TextEditingController? controller,
  Function()? ontap,
  required String labelText,
  required IconData prefix,
  IconData? suffix,
  bool password = false,
  TextInputType? type,
  Function()? obsecureButton,
  required FormFieldValidator textValidator,
}) =>
    TextFormField(
        controller: controller,
        onTap: ontap,
        // controller: passwordController,
        validator: textValidator,
        keyboardType: type,
        obscureText: password,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(onPressed: obsecureButton, icon: Icon(suffix))
              : null,
        ));

// ignore: non_constant_identifier_names
Widget BuildTaskItem({required Map map, context}) => Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: map['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                '${map['date']}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13,color: Colors.white),

              ),
              radius: 33,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${map['title']}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${map['time']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .UpdateDatabase(id: map['id'], status: 'done');
              },
              icon: Icon(Icons.done),
              color: Colors.green[500],
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .UpdateDatabase(id: map['id'], status: 'archive');
              },
              icon: Icon(Icons.archive),
              color: Colors.black45,
            )
          ],
        ),
      ),
    );

Widget taskBuilder({required List<Map> tasks, context}) {
  return ConditionalBuilder(
      condition: tasks.length > 0,
  builder: (context) => ListView.separated(
  itemBuilder: (context, index) => BuildTaskItem(
  map: tasks[index], context: context),
  separatorBuilder: (context, index) => Container(
  width: double.infinity,
  height: 1,
  color: Colors.grey[300],
  ),
  itemCount: tasks.length),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Add new tasks',style: TextStyle(fontSize: 20),),
      Icon(Icons.menu,size: 40,)],
    ),
  ));
}
