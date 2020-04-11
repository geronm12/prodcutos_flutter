import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patronblock/src/blocs/productos_block.dart';
import 'package:patronblock/src/models/producto_model.dart';
import 'package:patronblock/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  
  final formKey = GlobalKey<FormState>();
  
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductoModel producto = new ProductoModel();
  ProductosBloc productosBloc;
  bool _guardando = false;

  File foto;

  
  @override
  Widget build(BuildContext context) {
    
    productosBloc = new ProductosBloc();
    
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null)
    {
      producto = prodData;
    }
    
    return Scaffold(
    appBar: AppBar(
    title: Text('Producto'),
    actions: <Widget>[
    IconButton(
    icon:  Icon(Icons.photo_size_select_actual),
    onPressed: _selecionarFoto,
    ),
    
    IconButton(
    icon: Icon(Icons.camera_alt),
    onPressed: _tomarFoto,
    )

    ]),
    key: scaffoldKey,
    body: SingleChildScrollView(
    child: Container(
    padding: EdgeInsets.all(15.0),
    child: Form(
    key: formKey,
    child: Column(
    children: <Widget>[
    _mostrarFoto(),
    _crearNombre(),
    _crearPrecio(),
    _crearDisponible(),
    _crearBoton()

    ]),


    ))));
  }

   Widget _crearNombre()
  {
    
      return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
      labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (value){
      if(value.length < 3)
      {
        return 'Ingrese el nombre del producto';
      } else{
        return null;
      }


      },   

      
   


      );


  }

  Widget _crearPrecio()
  { 
      return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
      labelText: 'Precio',
      ),   
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value)
      {
         if(utils.isNumeric(value)){
           return null;
         }else
         {
           return 'Sólo números';
         }
      },
      );
     
  }

Widget _crearDisponible()
{
  return SwitchListTile(
  value: producto.disponible,
  title: Text('Disponible'),
  onChanged: (value) => setState((){
  producto.disponible = value;
  }),
  activeColor: Colors.deepPurple,

  );
}



Widget _crearBoton()
{
  return RaisedButton.icon(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  color: Colors.deepPurple,
  textColor: Colors.white,
  label: Text('Guardar'),
  icon: Icon(Icons.save),
  onPressed: (_guardando) ? null : _submit,
  );
}

void _submit() async
{
  if(!formKey.currentState.validate()) return;
  
  formKey.currentState.save();    
  
  setState(() { _guardando = true; });
    
   if(foto != null)
   {
     producto.photoUrl =  await productosBloc.subirFoto(foto);
     
   }

   


  if(producto.id == null)
  {
    productosBloc.agregarProducto(producto);
  }else
  {
    productosBloc.editarProducto(producto);
  }

   mostrarSnackbar("Registro Guardado");

   Navigator.pop(context);

 }

 void mostrarSnackbar(String mensaje)
 {
     final snackbar = SnackBar(
     content: Text(mensaje),
     duration: Duration(milliseconds: 1500),
     );

     scaffoldKey.currentState.showSnackBar(snackbar);

 }

 Widget _mostrarFoto(){
  
  if(producto.photoUrl != null)
  {
     return FadeInImage(
     image: NetworkImage(producto.photoUrl),
     placeholder: AssetImage('assets/loading.gif'),
     height: 300.0,
     fit: BoxFit.cover
     );

  }else{
     
    if(foto != null)
   {
      return Image.file(foto, fit: BoxFit.cover, height: 300.0);
   }
    
    return Image.asset('assets/no-image.png');
  }

   

 }



 _selecionarFoto() async
 {
     _procesarImagen(ImageSource.gallery);    
 }

 _tomarFoto() async
 {
    _procesarImagen(ImageSource.camera);
 }


_procesarImagen (ImageSource tipo) async
{
    foto = await ImagePicker.pickImage(
    source: tipo
    );

    if(foto != null)
    {
      producto.photoUrl = null;
    }

    setState(() {});
     
}


}