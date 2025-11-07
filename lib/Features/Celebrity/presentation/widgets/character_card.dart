import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:chat_with_charachter/Features/Chats/presentation/views/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../Core/Providers/create_session_provider.dart';
import '../../../../generated/l10n.dart';
import '../../../Chats/presentation/providers/chat_session_provider.dart';
class CharacterCard extends ConsumerWidget {
  final CelebrityEntity entity;
  const CharacterCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final createSessionViewModel=ref.read(createSessionViewModelProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          final session = await createSessionViewModel.createSession(entity.id!);
          ref.read(chatSessionsViewModelProvider.notifier).addSession(session);
          

          if (context.mounted) {
            Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, animation, __) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation);

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: ChatPage(entitySession: session),
                  ),
                );
              },
            ));
          }
        },

        child: Container(
          width: double.infinity,
          height: 0.3.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            //border: Border.all(color: AppColors.black1,),
            color: AppColors.black1,
        
              image: DecorationImage(

        
                image: CachedNetworkImageProvider(entity.imageUrl ?? "",
        
                ),
              filterQuality: FilterQuality.high,
                  fit: BoxFit.cover
              )
          ),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 50.r),
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  bottom: 100.h,
                  child:Text(entity.name,style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                    fontSize: 50.sp
        
              ),) ),
              Positioned(
                  left: 0,
                  bottom: 50.h,
                  child:Text(S.of(context).createYourCharacterWithUs,style: TextStyle(
                      color: Colors.white,
        
                      fontSize: 40.sp
        
                  ),) ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
