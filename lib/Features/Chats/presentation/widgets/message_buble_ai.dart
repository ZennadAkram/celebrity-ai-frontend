import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Chats/presentation/widgets/triangle_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MessageBableAi extends StatelessWidget {

  const MessageBableAi({super.key, required this.message, required this.time, required this.url});
  final String message;
  final DateTime time;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width*0.17,
                    ),
                    padding: EdgeInsets.only(top: 16,right: 16,left: 20,bottom: 20),

                    decoration: BoxDecoration(
                        color:AppColors.black1,


                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),

                        )
                    ),
                    child: Text(message,style: TextStyle(
                        color:AppColors.white2,
                        fontSize: 16
                    ),),


                  ),
                  Positioned(
                      bottom: -50,
                      left: 0,
                      child:  ClipPath(
                        clipper: TriangleClipperAi(),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: AppColors.black1,
                        ),

                      )),
                  Positioned(
                    bottom: -52,
                    left: -15,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(0),
                      child: ClipOval(child: CachedNetworkImage(imageUrl: url,fit: BoxFit.fill,))
                    ),

                  ),

                  Positioned(
                      bottom: -23,
                      right: 5,
                      child: Text(time.hour.toString()+":"+(time.minute<10?"0"+time.minute.toString():time.minute.toString()),style: TextStyle(
                          color: Color.fromRGBO(136, 136, 136,1),
                          fontSize: 12
                      ),)
                  )
                ]

            ),
          )
        ]);
  }
}
