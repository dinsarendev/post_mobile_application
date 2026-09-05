import 'package:post_mobile_application/routes/app_route_name.dart';

class Menu {
  int? id;
  String? nameEn, nameKm, routeName;

  Menu({this.id, this.routeName, this.nameKm, this.nameEn});

  static List<Menu> getAllMenus(){
    return[
      Menu(id: 1,nameKm: "Posts",nameEn: "Posts", routeName: AppRouteName.adminPost),
      Menu(id: 2,nameKm: "Post Categories",nameEn: "Post Categories", routeName: AppRouteName.adminPostCategory),
      Menu(id: 3,nameKm: "Articles",nameEn: "Articles", routeName: AppRouteName.adminPost),
      Menu(id: 4,nameKm: "Settings",nameEn: "Settings", routeName: AppRouteName.settings)
    ];
  }
}
