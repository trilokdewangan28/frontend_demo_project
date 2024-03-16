import 'package:demo_project/LoginScreen.dart';
import 'package:demo_project/Screen/RegistrationScreen.dart';
import 'package:demo_project/config/StaticMethod.dart';
import 'package:demo_project/config/apis.dart';
import 'package:flutter/material.dart';
class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> productList = [];
  bool isLoading = false;
  bool mounted = false;
  _firstLoad()async{
    print('fetch product called');
    mounted=true;
    if(mounted){
      setState(() {
        isLoading = true;
      });
    }
    var url = Uri.parse(fetchProduct);
    final res = await StaticMethod.fetchProduct(url);
    if(res['success']==true){
      if(res['result']!=null){
        print(res);
        setState(() {
          productList = res['result'];
          isLoading = false;
        });
      }else{
        productList=[];
        setState(() {
          isLoading = false;
        });
      }
    }else{
      setState(() {
        isLoading = false;
      });
      print(res);
      StaticMethod.showDialogBar('error fetching product', Colors.red);
    }
  }
  @override
  void initState() {
    _firstLoad();
    super.initState();
  }
  @override
  void dispose() {
    mounted  = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child: Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));}, icon: Icon(Icons.person_add_outlined)),
          IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));}, icon: Icon(Icons.login))
        ],
      ),
      body: isLoading==true? Center(child: CircularProgressIndicator(),): productList.length==0 ? Center(child: Text('empty list')) : Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index){
              final product = productList[index];
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${product['name']}'),
                      Text(product['description']),
                      Text(product['count'].toString())
                    ],
                  )
              );
            }
        ),
      ),
    ), onRefresh: ()async{
      _firstLoad();
    });
  }
}
