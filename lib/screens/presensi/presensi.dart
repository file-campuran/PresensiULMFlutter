import 'dart:convert';

import 'package:absen_online/components/MyButton.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:dio/dio.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';

import 'package:image_editor/image_editor.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:device_info/device_info.dart';
import 'package:trust_fall/trust_fall.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/components/ColorLoader.dart';
import 'package:absen_online/components/FacePainter.dart';

import 'dart:ui' as ui;

List<CameraDescription> cameras;

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

class Presensi extends StatefulWidget {
  const Presensi({Key key}) : super(key: key);

  PresensiState createState() => PresensiState();
}

class PresensiState extends State<Presensi> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var infoPresensi;
  var responseStatus;

  bool isSendPresensi = false;

  double _bottomPanelSliderHeightOpen;
  double _bottomPanelSliderHeightClosed = 95.0;

  CameraController controller;
  bool isReady = false;
  bool showCamera = true;

  double latitude, longitude;
  bool mocked;
  String imagePath;
  String filePath;
  String deskripsi;
  bool isRoot = false, isFakeGps = false, isIos = false;
  bool isRefreshLoading = false;
  bool isRealDevice = true;

  Map<String, dynamic> deviceInfo = Map();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  bool cameraInitializated = false;
  bool pictureTaked = false;

  Size imageSize;
  Face faceDetected;

  LocationError errorLocation = new LocationError();
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    controller.dispose();
    // myLocation.closeStream();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setupCameras();
    _getLocation();
    initPlatformState();
    initPresensi();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      isRoot = await TrustFall.isJailBroken;
      isRealDevice = await TrustFall.isRealDevice;

      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch (e) {}

    setState(() {
      deviceInfo = deviceData;
    });
  }

  final myLocation = MyLocation();
  void _getLocation() async {
    setState(() {
      errorLocation.message = '';
      errorLocation.status = false;
    });

    final isEnabled = await myLocation.gpsServiceEnable();
    if (isEnabled) {
      UtilLogger.log('LOCATION', 'SERVICE LOCATION IS ENABLE');
    } else {
      setState(() {
        errorLocation.message = Translate.of(context).translate('ask_location');
        errorLocation.status = true;
      });

      UtilLogger.log('LOCATION', 'SERVICE LOCATION IS DISABLED');
    }

    final position = await myLocation.getLoacation();
    UtilLogger.log('LOCATION', 'POSITION INITIALIZE');
    if (position != null) {
      print(position.accuracy);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        isFakeGps = position.mocked;
      });
    } else {
      setState(() {
        errorLocation.message =
            Translate.of(context).translate('location_timeout');
        errorLocation.status = true;
      });
    }
  }

  void initPresensi() {
    // apiProvider.getInfoPresensi().then((value) => setState(() {
    //       infoPresensi = value;
    //       responseStatus = value;
    //       isRefreshLoading = false;
    //     }));
  }

  Future<void> sendPresensi() async {
    Map<String, dynamic> dataPresensi = new Map();
    dataPresensi['latitude'] = latitude;
    dataPresensi['longitude'] = longitude;
    dataPresensi['deskripsi'] = deskripsi;
    dataPresensi['deviceIsRoot'] = isRoot ? 1 : 0;
    dataPresensi['deviceIsFakeGps'] = isFakeGps ? 1 : 0;
    dataPresensi['deviceIsIos'] = Platform.isIOS ? 1 : 0;
    // dataPresensi['isEmulator'] = !isRealDevice;
    dataPresensi['deviceInfo'] = jsonEncode(deviceInfo);
    // dataPresensi['face_data'] = _faces;

    dataPresensi['fileGambar'] = await MultipartFile.fromFile(
      imagePath,
      filename: imagePath.split("/").last + '.jpg',
    );

    if (filePath != null) {
      dataPresensi['fileBerkas'] = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split("/")?.last,
      );
    }

    try {
      setState(() {
        isSendPresensi = true;
      });
      final response = await PresensiRepository().setPresensi(dataPresensi);

      if (response.code == CODE.SUCCESS) {
        print('SUCCESS');
        print(response.data);
      } else {
        print('ERROR');
        List<String> error = [];
        response.message.forEach((k, v) => error.add('- $v'));
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ERROR'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: error.map((e) => Text(e)).toList(),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
      setState(() {
        isSendPresensi = false;
      });
    } catch (e) {}
  }

  chooseFile() async {
    try {
      File file = await FilePicker.getFile();
      setState(() {
        filePath = file.path;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    _bottomPanelSliderHeightOpen = MediaQuery.of(context).size.height * .6;
    _bottomPanelSliderHeightClosed = MediaQuery.of(context).size.height * .28;

    return Theme(
      data: Theme.of(context).copyWith(
        brightness: Brightness.dark,
      ),
      child: Scaffold(
        // floatingActionButton: _buttonSendPresensi(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              SlidingUpPanel(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
                backdropEnabled: true,
                maxHeight: _bottomPanelSliderHeightOpen,
                minHeight: _bottomPanelSliderHeightClosed,
                parallaxEnabled: false,
                parallaxOffset: .5,
                body: _panelBody(),
                panelBuilder: (sc) => _bottomPanelSlider(sc),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0)),
              ),
              // FAB
              _buttonSendPresensi()
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelBody() {
    return Container(
      child: Stack(
        children: <Widget>[
          // CAMERA PREVIEW
          Container(
            height: MediaQuery.of(context).size.height -
                _bottomPanelSliderHeightClosed +
                65,
            child: showCamera ? cameraPreviewWidget() : imagePreviewWidget(),
          ),
          // BACKDROP
          Positioned(
            top: 0,
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    // Colors.black12,
                    Colors.black45,
                    Colors.black.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          // TOGGLE WIDGET
          Positioned(
            right: 0,
            top: 30,
            child: toggleWidget(),
          ),
          //BUTTON CAPTURE
          Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: _bottomPanelSliderHeightClosed + 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  showCamera
                      ? buttonTake(
                          icon: Icons.camera_enhance,
                          onTap: () {
                            print('CAPTURE');
                            eventTakePicture();
                          })
                      : buttonTake(
                          icon: Icons.refresh,
                          onTap: () {
                            print('RE CAPTURE');
                            eventRecapture();
                          }),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buttonSendPresensi() {
    if (imagePath != null) {
      return Positioned(
        right: 20.0,
        bottom: 20,
        child: FloatingActionButton(
          child: !isSendPresensi
              ? Icon(Icons.save, color: Colors.white)
              : CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(Colors.grey),
                ),
          onPressed: () {
            if (!isSendPresensi) {
              sendPresensi();
            }
          },
          backgroundColor:
              isSendPresensi ? Colors.grey : Theme.of(context).primaryColor,
        ),
      );
    }

    return Container();
  }

  Widget buttonTake(
      {IconData icon, double size = 55, background: true, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          icon,
          size: size / 2.5,
          color: Colors.white,
        ),
        decoration: background
            ? BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                shape: BoxShape.circle,
              )
            : BoxDecoration(),
      ),
    );
  }

  Widget _bottomPanelSlider(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        decoration: new BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(18.0),
              topRight: const Radius.circular(18.0)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 3,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: new ScrollBehavior()
                  ..buildViewportChrome(context, null, AxisDirection.down),
                child: ListView(
                  controller: sc,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Lottie.asset(
                            Images.Writting,
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            Translate.of(context).translate('presence'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _bottomPanelSliderContent(),
                    SizedBox(
                      height: 36.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomPanelSliderContent() {
    if (latitude != null) {
      return Container(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(Translate.of(context).translate('performance_description'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 4),
            TextFormField(
              keyboardType: TextInputType.multiline,
              // maxLines: 3,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  deskripsi = value;
                });
              },
              decoration: InputDecoration(
                  // labelText: 'Keterangan Kerja',
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    AppButton(
                      onPressed: chooseFile,
                      text: filePath == null
                          ? Translate.of(context).translate('choose_file')
                          : Translate.of(context).translate('change_file'),
                      disableTouchWhenLoading: true,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        filePath != null
                            ? filePath.split("/")?.last
                            : Translate.of(context)
                                .translate('choose_file_empty'),
                        softWrap: true,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  Application.remoteConfig.application.upload.max,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  Application.remoteConfig.application.upload.mime,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Column(children: [
        if (errorLocation.status) ...[
          Text(errorLocation.message),
          SizedBox(
            height: 10,
          ),
          MyButton(
            loading: false,
            text: 'Reload',
            icon: Icons.refresh,
            onPress: _getLocation,
          ),
        ] else ...[
          ColorLoader(),
          Text(Translate.of(context).translate('get_location')),
        ]
      ]);
    }
  }

  void showInSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget imagePreviewWidget() {
    // return Image.asset(imagePath);
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _image.width.toDouble(),
          height: _image.height.toDouble(),
          child: CustomPaint(
            painter: FacePainter(_image, _faces),
          ),
        ),
      ),
    );
  }

  Widget cameraPreviewWidget() {
    if (!isReady || !controller.value.isInitialized) {
      return Center(
        child: ColorLoader(),
      );
    }

    return AspectRatio(aspectRatio: 3 / 1, child: CameraPreview(controller));
  }

  Widget dragIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  CameraDescription cameraDescription(CameraLensDirection lensDirection) {
    return cameras.firstWhere(
      (CameraDescription camera) => camera.lensDirection == lensDirection,
    );
  }

  //FUNCTION CAMERA
  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(
          cameraDescription(CameraLensDirection.front), ResolutionPreset.high,
          enableAudio: true);
      await controller.initialize();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  Widget captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null && controller.value.isInitialized
              ? eventTakePicture
              : null,
        ),
      ],
    );
  }

  void eventTakePicture() async {
    UtilLogger.log('INIT TAKE PICTURE', DateTime.now().toString());
    String filePath = await takePicture();
    UtilLogger.log('COMPLETE TAKE PICTURE', DateTime.now().toString());
    UtilLogger.log('TAKE PICTURE PATH', filePath);
    if (mounted) {
      if (controller.description.lensDirection == CameraLensDirection.front) {
        flipImage(filePath);
      } else {
        File file = new File(filePath);

        detectedImage(file);
      }
    }
  }

  Future flipImage(String filePath) async {
    UtilLogger.log('START FLIP PICTURE', DateTime.now().toString());

    final editorOption = ImageEditorOption();
    editorOption.addOption(FlipOption(horizontal: true));
    editorOption.outputFormat = OutputFormat.jpeg(88);

    File file = new File(filePath);
    File flipImage = await ImageEditor.editFileImageAndGetFile(
        file: file, imageEditorOption: editorOption);
    file.delete();

    UtilLogger.log('COMPLETE FLIP PICTURE', DateTime.now().toString());
    detectedImage(flipImage);
  }

  Future detectedImage(File fileRaw) async {
    UtilLogger.log('START DETECT FACE IMAGE', DateTime.now());
    final visionImage = FirebaseVisionImage.fromFile(fileRaw);
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(visionImage);

    final dataFaceFirebase = await fileRaw.readAsBytes();
    final decodeImage = await decodeImageFromList(dataFaceFirebase);

    UtilLogger.log('END DETECT FACE IMAGE', DateTime.now().toString());
    setState(() {
      imagePath = fileRaw.path;
      showCamera = false;

      _faces = faces;
      _image = decodeImage;
    });
  }

  ui.Image _image;
  List<Face> _faces;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/presensi';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (_) {
      return null;
    }
    return filePath;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showInSnackBar('Camera error $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget toggleWidget() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showCamera ? cameraTogglesRowWidget() : Container(),
          if (latitude != null) ...[
            buttonTake(
                icon: Icons.map,
                size: 50,
                background: false,
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.location,
                      arguments: LocationModel(1, '', latitude, longitude));
                }),
          ],
        ],
      ),
    );
  }

  Widget cameraTogglesRowWidget() {
    if (isReady) {
      return controller.description.lensDirection == CameraLensDirection.front
          ? buttonTake(
              icon: Icons.camera_rear,
              size: 50,
              background: false,
              onTap: () {
                onNewCameraSelected(
                    cameraDescription(CameraLensDirection.back));
              })
          : buttonTake(
              icon: Icons.camera_front,
              size: 50,
              background: false,
              onTap: () {
                onNewCameraSelected(
                    cameraDescription(CameraLensDirection.front));
              });
    }

    return Container();
  }

  void eventRecapture() {
    File _tempFile = File(imagePath);
    _tempFile.delete();
    setState(() {
      showCamera = true;
      imagePath = null;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'app_version': Application.version,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
      // 'app_version': Dictionary.version,
    };
  }
}

class LocationError {
  bool status = false;
  String message = '';

  LocationError({this.status, this.message});
}
