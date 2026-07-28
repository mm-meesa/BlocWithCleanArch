import 'package:blocwithcleanarch/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/fincluddata_bloc.dart';

class FincludeDataScreen extends StatelessWidget {
  const FincludeDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FincluddataBloc>()..fetchAllUserDetails(),
      child: Scaffold(
        body: BlocBuilder<FincluddataBloc, FincluddataState>(
          builder: (context, state) {
            if (state is FincluddataLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is FincluddataError) {
              return Center(child: Text(state.error));
            }
            if (state is FincluddataLoaded) {
              return userDetailsWidget(state, context);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget userDetailsWidget(FincluddataLoaded state, BuildContext context) {
    return ListView.builder(
      itemCount: state.allUserDetails.length,
      itemBuilder: (_, index) {
        final details = state.allUserDetails[index];
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
