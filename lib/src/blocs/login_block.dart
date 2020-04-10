import 'dart:async';

import 'package:patronblock/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {

final _emailController    = new BehaviorSubject<String>();
final _passwordController = new BehaviorSubject<String>();




//Recuperar los datos del stream

Stream<String> get emailStream =>  _emailController.stream.transform(validarEmail);
Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);



//Insertar valores al stream

Function(String) get changeEmail => _emailController.sink.add;
Function (String) get changePassword => _passwordController.sink.add;

//Stream Transformers

Stream<bool> get formValidStream => 
      CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);


//Obtener el último valor ingresado a los streams
String get email => _emailController.value;

String get password => _passwordController.value;


//Cerrar los streams cuando no los necesito


void dispose()
{
  _emailController?.close();

  _passwordController?.close();

}












}