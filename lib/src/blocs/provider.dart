import 'package:flutter/material.dart';
import 'package:patronblock/src/blocs/login_block.dart';
import 'package:patronblock/src/blocs/productos_block.dart';
export 'package:patronblock/src/blocs/login_block.dart';
export 'package:patronblock/src/blocs/productos_block.dart';

class Provider extends InheritedWidget 
{
  
  
  static Provider _instancia;

  factory Provider({Key key, Widget child})
  {
    if(_instancia == null)
    {
      _instancia = new Provider._internal(key:key, child: child);
    }
   
    return _instancia;
  }

  Provider._internal({Key key, Widget child})
          :super(key:key, child: child);


  final loginBloc      = new LoginBloc();

  final _productosBloc = new ProductosBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
    
     
  static LoginBloc of (BuildContext context){
  return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  
    
  static ProductosBloc productosBloc (BuildContext context){
  return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }


}