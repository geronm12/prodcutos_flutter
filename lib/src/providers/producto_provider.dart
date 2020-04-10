import 'dart:convert';

import 'package:patronblock/src/models/producto_model.dart';
import 'package:http/http.dart' as http;


class ProductosProvider 
{
   
   final String _url = "https://flutterproject-682e1.firebaseio.com";
    
   Future<bool> crearProducto(ProductoModel producto) async{
   
   final url = '$_url/productos.json';

   final res = await http.post(url, body: productoModelToJson(producto));
   
   final decodedData = json.decode(res.body);
 
   print(decodedData);

   return true;
   
   
   }
  

   Future<List<ProductoModel>> cargarProductos() async {
   
   final url = '$_url/productos.json';


   final resp = await http.get(url);

      
   final Map<String, dynamic> decodedData = json.decode(resp.body);
   final List<ProductoModel> productos = new List();

    if(decodedData == null) return [];  
    
    decodedData.forEach((id, prod){
       
    final prodTemp = ProductoModel.fromJson(prod);
    prodTemp.id = id;

    productos.add(prodTemp);  
    
    });
 

    return productos;


   }

   
   Future<int> borrarProducto (String id) async
   {

      final url = '$_url/productos/$id.json';

      final resp = await http.delete(url);

      return 1;


   }

}