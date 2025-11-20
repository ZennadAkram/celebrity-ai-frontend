
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Features/Chats/presentation/widgets/user_triangle.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../Core/Constants/app_colors.dart';
import '../../../../Core/Providers/user_provider.dart';

class MessageBableUser extends HookConsumerWidget {
  const MessageBableUser(this.message, this.time, {super.key});

  final String message;

  final DateTime time;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final user=ref.watch(userProvider);
  return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Stack(
              clipBehavior: Clip.none,
              children:[ Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width*0.17,
                ),
                padding: EdgeInsets.only(top: 16,right: 16,left: 20,bottom: 20),
                decoration: BoxDecoration(
                    color: AppColors.brand1,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),

                    )
                ),
                child: Text(message,style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),


              ),
                Positioned(
                  bottom: -20,
                  right: 0,
                  child:  ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: AppColors.brand1,
                    ),
                  ),),

                Positioned(
                  bottom: -50,
                  right: -12,
                  child: ClipOval(

                    child:user != null? CachedNetworkImage(imageUrl:user.avatarUrl??"",width: 45,height: 45,fit: BoxFit.cover,): Icon(Icons.account_circle,color: AppColors.grey1,size: 45,)),

                ),
                Positioned(
                    bottom: -23,
                    left: 0,
                    child: Text(time.hour.toString()+":"+(time.minute<10?"0"+time.minute.toString():time.minute.toString()),style: TextStyle(
                        color: Color.fromRGBO(136, 136, 136,1),
                        fontSize: 12
                    ),)
                )
              ],

            ),
          ),


        ]
    );
  }
}
