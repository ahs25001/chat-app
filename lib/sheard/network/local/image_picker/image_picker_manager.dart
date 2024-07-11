import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerManager {
  static final ImagePicker picker = ImagePicker();

  static Future<XFile?> getImageFromCamera() async {
    Permission permission = Permission.camera;
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus.isDenied) {
      permissionStatus = await permission.request();
      if (permissionStatus.isGranted || permissionStatus.isLimited) {
        XFile? image = await picker.pickImage(source: ImageSource.camera);
        return image;
      }
    } else {
      XFile? image = await picker.pickImage(source: ImageSource.camera);
      return image;
    }
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image;
  }

  static Future<XFile?> getImageFromGallery() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }
}
