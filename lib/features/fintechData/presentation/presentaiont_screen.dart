import 'package:blocwithcleanarch/core/di/injection.dart';
import 'package:blocwithcleanarch/features/fintechData/presentation/bloc/presentaiont_bloc.dart';
import 'package:blocwithcleanarch/features/fintechData/presentation/bloc/presentaiont_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PresentaiontBloc>()..fetchAllPresentaiontDetials(),
      child: Scaffold(
        appBar: AppBar(title: Text("Presentation"),),
        body: SafeArea(
          child: BlocBuilder<PresentaiontBloc, PresentaiontState>(
            builder: (context,state){


              if(state is PresentaiontLoading){
                return Center(child: CircularProgressIndicator());
              }

              if(state is PresentaiontError){
                return Center(child: Text(state.errorMsg));
              }

              if(state is PresentaiontLoaded){
                return userDetailsWidget(state, context);
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }


  Widget userDetailsWidget(PresentaiontLoaded state, BuildContext context) {
    return ListView.builder(
      itemCount: state.allPresentaiontData.length,
      itemBuilder: (_, index) {
        final details = state.allPresentaiontData[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(details.title ?? ""),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.grey,
              )
            ],
          ),
        );
      },
    );
  }
}
