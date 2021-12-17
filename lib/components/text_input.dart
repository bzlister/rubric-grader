import 'package:flapp/models/factor.dart';
import 'package:flutter/material.dart';

Widget TextInput(Bloc bloc) {
  return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snap) {
        return StreamBuilder(
            stream: bloc.password,
            builder: (context, snapshot) {
              return TextField(
                obscureText: true,
                onChanged: bloc.changePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  errorText: snapshot.error,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: snap.hasData ? bloc.submit : null,
              );
            });
      });
}
