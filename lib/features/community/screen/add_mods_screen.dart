import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({Key? key, required this.name}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String>modUids ={};
  int cnt=0;
  void addUid(String uid){
    setState(() {
      modUids.add(uid);
    });
  }
  void removeUid(String uid){
    setState(() {
      modUids.remove(uid);
    });
  }
  void saveMods(){
    ref.read(communityControllerProvider.notifier).addMods(widget.name , modUids.toList(), context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed:saveMods,
              icon: Icon(
                Icons.done_outline_outlined,
                color: Pallete.greenColor,
              ))
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) {
              return ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (context, index) {
                  final member = community.members[index];
                 return  ref.watch(getUserDataProvider(member)).when(
                        data: (user) {
                          if(community.mods.contains(member) && cnt==0){
                            modUids.add(member);
                          }
                          cnt++;
                          return CheckboxListTile(
                            value: modUids.contains(user.uid),
                            onChanged: (value){
                              if(value!){
                                removeUid(user.uid);
                                addUid(user.uid);
                              }else{
                                removeUid(user.uid);
                              }
                            },
                            title: Text(user.name),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
