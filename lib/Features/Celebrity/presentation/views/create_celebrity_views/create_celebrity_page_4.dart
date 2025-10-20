import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:io';

import '../../../../../Core/Constants/app_colors.dart';
import '../../../../../Core/Services/file_helper.dart';
import '../../../../../Core/Services/image_picker.dart';
import '../../../domain/entities/celebrity.dart';
import '../../providers/celebrity_providers.dart';
import '../../providers/create_celebrity_providers/avatar_select_provider.dart';
import 'create_celebrity_page_5.dart';

class CreateCelebrityPage4 extends ConsumerWidget {
  const CreateCelebrityPage4({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel=ref.watch(viewModelProvider.notifier);
    final viewModelChanger=ref.read(viewModelProvider.notifier);
    final colorSelected=ref.watch(colorSelectedProvider);
    final colorSelector=ref.read(colorSelectedProvider.notifier);
    final picker = PickImage();
    final imageSelector=ref.read(imageSelectorProvider.notifier);
    final selectedImage=ref.watch(imageSelectorProvider);

    final List<String> avatarPaths = [
      'images/avatars/3D/boy3D.png',
      'images/avatars/3D/man3D.png',
      'images/avatars/3D/man2_3D.png',
      'images/avatars/3D/girl3D.png',
      'images/avatars/3D/woman3D.png',
      'images/avatars/3D/woman2_3D.png',
      'images/avatars/3D/woman3_3D.png',
      'images/avatars/3D/boy2_3D.png',
      'images/avatars/3D/man3_3D.png',
      'images/avatars/anime/luffy.png',
      'images/avatars/anime/itachi.png',
      'images/avatars/movies/hulk.png',
      'images/avatars/movies/spider_man.png'
    ];

    final List<Color> avatarBgColors = [
      // 🩵 Blue / Aqua / Cyan tones
      const Color(0xFF001F3F), // deep navy
      const Color(0xFF003366), // ocean blue
      const Color(0xFF004B8D), // royal blue
      const Color(0xFF006494), // deep teal blue
      const Color(0xFF0077B6), // marine blue
      const Color(0xFF0096C7), // aqua blue
      const Color(0xFF00B4D8), // cyan
      const Color(0xFF48CAE4), // light cyan
      const Color(0xFF90E0EF), // soft blue
      const Color(0xFFCAF0F8), // very light blue

      // 💜 Violet / Purple tones
      const Color(0xFF1A0033), // dark indigo
      const Color(0xFF3B0A45), // wine purple
      const Color(0xFF5A189A), // royal violet
      const Color(0xFF7B2CBF), // bright violet
      const Color(0xFF9D4EDD), // neon purple
      const Color(0xFFC77DFF), // lilac
      const Color(0xFFE0AAFF), // soft lavender
      const Color(0xFFF3E8FF), // pale lavender

      // 🔴 Red / Pink tones
      const Color(0xFF3F000F), // deep burgundy
      const Color(0xFF5C0029), // wine red
      const Color(0xFF7F1D1D), // dark red
      const Color(0xFFA4161A), // crimson red
      const Color(0xFFC1121F), // blood red
      const Color(0xFFE5383B), // bright red
      const Color(0xFFBA181B), // fire red
      const Color(0xFFFF4D6D), // pinkish red
      const Color(0xFFFF758F), // coral
      const Color(0xFFFFB3C1), // rose
      const Color(0xFFFFCCD5), // soft pink

      // 🟠 Orange / Gold tones
      const Color(0xFF331A00), // dark brown orange
      const Color(0xFF663300), // rustic orange
      const Color(0xFF8B4513), // leather brown
      const Color(0xFFB45309), // burnt orange
      const Color(0xFFEA580C), // orange
      const Color(0xFFF97316), // vivid orange
      const Color(0xFFF59E0B), // amber
      const Color(0xFFFBBF24), // golden
      const Color(0xFFFCD34D), // light gold
      const Color(0xFFFFE5B4), // cream

      // 💚 Green / Mint tones
      const Color(0xFF003300), // forest dark
      const Color(0xFF064E3B), // deep forest
      const Color(0xFF065F46), // dark teal green
      const Color(0xFF047857), // emerald
      const Color(0xFF10B981), // jade green
      const Color(0xFF34D399), // mint green
      const Color(0xFF6EE7B7), // pale mint
      const Color(0xFFA7F3D0), // soft pastel green
      const Color(0xFFCCFBEF), // icy green
      const Color(0xFFE6FFF9), // very light green

      // ⚪ Neutral / Gray tones
      const Color(0xFF0F0F0F), // true black
      const Color(0xFF1A1A1A), // matte black
      const Color(0xFF1F2937), // charcoal gray
      const Color(0xFF374151), // steel gray
      const Color(0xFF4B5563), // medium gray
      const Color(0xFF6B7280), // slate gray
      const Color(0xFF9CA3AF), // silver gray
      const Color(0xFFD1D5DB), // light silver
      const Color(0xFFF3F4F6), // near white
      const Color(0xFFFFFFFF), // pure white

      // 🟣 Cinematic / Fantasy tones
      const Color(0xFF10002B), // deep galaxy
      const Color(0xFF240046), // purple space
      const Color(0xFF3C096C), // deep violet
      const Color(0xFF5A189A), // rich purple
      const Color(0xFF7B2CBF), // cosmic violet
      const Color(0xFF9D4EDD), // neon violet
      const Color(0xFF6C63FF), // electric indigo
      const Color(0xFF00F5D4), // cyber aqua
      const Color(0xFF00BBF9), // neon blue
      const Color(0xFF3A86FF), // strong cyan
      const Color(0xFF8338EC), // bright purple
      const Color(0xFFFF006E), // neon pink
      const Color(0xFFFFBE0B), // neon yellow
      const Color(0xFFFB5607), // orange-red
      const Color(0xFFFFA630), // warm highlight
      const Color(0xFF5C2A9D), // fantasy deep purple
      const Color(0xFF8C1EFF), // bright futuristic purple
      const Color(0xFFB5179E), // magenta glow
      const Color(0xFF4361EE), // indigo glow
      const Color(0xFF4895EF), // sky glow
      const Color(0xFF4CC9F0), // teal glow
    ];

    final selected = ref.watch(avatarSelectProvider);
    final select = ref.read(avatarSelectProvider.notifier);
    final bgSelected = ref.watch(avatarBgSelectProvider);
    final bgSelect = ref.read(avatarBgSelectProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50.r, left: 40.r, right: 40.r),
              height: 200.h,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    color: AppColors.white2,
                  ),
                  Text(
                    'Create Character',
                    style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 60.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: () async{
                      File? file=await picker.pickFromCamera();
                      if(file!=null){
                        imageSelector.state=file;
                      }
                    },
                    icon: SvgPicture.asset('images/svg/scann.svg'),
                  ),
                ],
              ),
            ),

            // FIXED: Added proper content to the Expanded widget
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.r),
                child: Container(
                  // Add your main content here
                  // For now, I'm adding a placeholder

                  child:selectedImage == null ?
                  Center(child:  Text('No image selected.',style: TextStyle(
                    color: AppColors.white2,
                    fontSize: 50.sp
                  ),),)
                      : SizedBox(

                    child: Stack(
                      children: [

                      // Big circle overflowing top
                      Positioned(
                      // half the circle outside screen
                      left: 0, // shift left so it’s centered
                      child: Container(
                        padding: EdgeInsets.all(0.15.sw),
                        width: 0.9.sw, // 150% of screen width
                        height: 0.9.sw,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              colorSelected.withOpacity(0.7),                 // center
                              colorSelected.withOpacity(0) // fade out
                            ],
                            radius: 0.53,
                          ),
                        ),
                        child:ClipOval(

                          child: Image.file(selectedImage,
                            opacity: AlwaysStoppedAnimation(0.8),
                            height: 150.h,
                            width: 150.h,
                            fit: BoxFit.cover,
                          ),

                        ),
                      ),
                        
                    ),
                   ]
                    )

                  ),
                ),
              ),
            ),
            Container(
              height: 0.47.sh,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 65.r, vertical: 70.r),
              decoration: BoxDecoration(
                color: AppColors.black1.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Avatar',
                    style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 50.sp,
                    ),
                  ),
                  SizedBox(height: 0.02.sh),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async{
                         imageSelector.state= await picker.pickImage();
                          if (selectedImage != null) {
                            if (kDebugMode) {
                              print('Picked image: ${selectedImage.path}');
                            }
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.brand1,
                        ),
                        icon: Icon(Icons.add, color: Colors.white, size: 35),
                      ),
                      SizedBox(width: 40.w),
                      SizedBox(
                        width: 0.7.sw,
                        height: 180.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: avatarPaths.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: GestureDetector(
                                onTap: () async{ select.state = index;
                                File file = await FileHelper.assetToFile(avatarPaths[index]);
                                ref.read(imageSelectorProvider.notifier).state = file;
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected == index
                                          ? AppColors.secondary1
                                          : Colors.black,
                                      width: selected == index ? 2 : 1,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      avatarPaths[index],
                                      width: 160.h,
                                      height: 160.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.03.sh),
                  Text(
                    'Choose Background',
                    style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 50.sp,
                    ),
                  ),
                  SizedBox(height: 0.02.sh),
                  SizedBox(
                    width: 0.85.sw,
                    height: 0.12.sh,
                    child: ListView.builder(
                      itemCount: avatarBgColors.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () =>{ bgSelect.state = index,
                            colorSelector.state=avatarBgColors[index]
                          },
                          child: Container(
                            width: 0.15.sw,

                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                              color: avatarBgColors[index],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: bgSelected == index
                                    ? AppColors.secondary1
                                    : Colors.black,
                                width: bgSelected == index ? 2 : 1,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 0.03.sh,),
                  SizedBox(

                    width: double.infinity,
                    child: ElevatedButton( onPressed: selectedImage == null
                        ? null
                        : () {viewModelChanger.onCreateCelebrity(ref, selectedImage);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          maintainState: true,  // Keep previous route's state
                          builder: (context) => CreateCelebrityPage5()
                      ),
                    );
                      },


                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return AppColors.brand3; // your disabled color
                              }
                              return AppColors.brand1; // your active color
                            },
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 50.r),
                          ))

                        , child:Text("Create Celebrity",style: TextStyle(
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white2
                        ),)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}