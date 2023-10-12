import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class hivdata extends StatefulWidget {
  const hivdata({super.key});

  @override
  State<hivdata> createState() => _hivdataState();
}

class _hivdataState extends State<hivdata> {
  @override
  final  _namecontroller=TextEditingController();
  final  _rollnumbercontroller=TextEditingController();
  List<Map<String,dynamic>>_items=[];

  final _schoolbox=Hive.box('school_box');
  @override
  void initstate(){
    super.initState();
    _refreshitem();
  }
  void _refreshitem(){
  final data=_schoolbox.keys.map((Key){
    final item=_schoolbox.get(Key);
    return {"key":Key,"name":item["name"],"rollnumber":item['rollnumber']};
  }).toList();
  setState(() {
    _items=data.reversed.toList();
    print(_items.length);
  });
  }

  Future<void>_createitem(Map<String,dynamic>newitem)async{
    await _schoolbox.add(newitem);
    _refreshitem();
  }
  Future<void>_updateitem(int itemkey,Map<String,dynamic>item)async{
    await _schoolbox.put(itemkey, item);
    _refreshitem();
  }
  Future<void>_deleteitem(int itemkey)async{
    await _schoolbox.delete(itemkey);
    _refreshitem();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("an item has been deleted"))
    );
  }
  void _showfrom(BuildContext ctx,int?itemkey)async{
    if(itemkey!=null){
      final existingitem=
      _items.firstWhere((element) => element['key']==itemkey);
      _namecontroller.text=existingitem['name'];
      _rollnumbercontroller.text=existingitem['rollnumber'];
    }
    showModalBottomSheet(context: ctx,elevation: 5,isScrollControlled:true ,   
    builder:(_)=>Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
        top: 5,left: 15,right: 15),
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _namecontroller,
              decoration: InputDecoration( hintText: 'name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _rollnumbercontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'rollnumber'),
            ),
            SizedBox(
              height: 11,
            ),ElevatedButton(onPressed: (){
               if(itemkey==null){
              _createitem({
                "name":_namecontroller.text,
                "rollnumber":_rollnumbercontroller.text,
              });}
              if(itemkey!=null){
                _updateitem(itemkey,{
                  'name':_namecontroller.text.trim(),
                  'quantity':_rollnumbercontroller.text.trim()
                });
              }
            _namecontroller.text='';
            _rollnumbercontroller.text='';
            Navigator.of(context).pop();
            }, child: Text(itemkey==null?'creat new':'update')),
            SizedBox(height: 11,)
          ],
        ),
      ),
    ) ;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 224, 103),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 249, 129, 203),
        title: Text("hiv"),
        centerTitle: true,
      ),
      body:ListView.builder(
  itemCount: _items.length,
  itemBuilder: (_, index) {
    final currentitem = _items[index];

    // Check if name and quantity are not empty or null
    if (currentitem['name'] != null &&
        currentitem['name'].toString().isNotEmpty &&
        currentitem['rollnumber'] != null &&
        currentitem['rollnumber'].toString().isNotEmpty) {
      return Card(
        color: const Color.fromARGB(255, 167, 245, 170),
        margin: EdgeInsets.all(10),
        elevation: 3,
        child: ListTile(
          title: Text(currentitem['name'].toString()),
          subtitle: Text(currentitem['rollnumber'].toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _showfrom(context, currentitem['key']),
                icon: const Icon(Icons.edit),
                color: Colors.green,
              ),
              IconButton(
                onPressed: () => _deleteitem(currentitem['key']),
                icon: const Icon(Icons.delete),
                color: Colors.green,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  },
),

      floatingActionButton: FloatingActionButton(onPressed: ()=>_showfrom(context, null),
      child: Icon(Icons.add),),
    );
  }
}